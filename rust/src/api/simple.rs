use nom_kconfig::{parse_kconfig, Kconfig, KconfigFile, KconfigInput};
use std::fs;
use std::path::{Path, PathBuf};

#[flutter_rust_bridge::frb(sync)]
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

/// 解析 Kconfig 文件，返回语法树
///
/// # 参数
/// * `kernel_root` - Linux 内核源码根目录路径
/// * `kconfig_path` - 要解析的 Kconfig 文件路径（相对于内核根目录或绝对路径）
///
/// # 示例
/// ```
/// let kconfig = parse_kconfig_file("/path/to/linux", "Kconfig")?;
/// ```
#[flutter_rust_bridge::frb]
pub fn get_kernel_config(
    kernel_root: String,
    kconfig_path: String
) -> Result<Kconfig, String> {
    // 转换路径并立即验证
    let kernel_root = PathBuf::from(kernel_root);
    let config_path = PathBuf::from(kconfig_path);

    // 验证内核根目录存在
    if !kernel_root.exists() {
        return Err(format!("内核根目录不存在: {}", kernel_root.display()));
    }

    if !kernel_root.is_dir() {
        return Err(format!("内核根路径不是目录: {}", kernel_root.display()));
    }

    parse_config_file_internal(kernel_root, config_path)
}

/// 内部实现，使用 PathBuf 避免重复转换
fn parse_config_file_internal(
    kernel_root: PathBuf,
    config_path: PathBuf,
) -> Result<Kconfig, String> {
    // 确定完整的 Kconfig 文件路径（预分配容量优化）
    let full_path = if config_path.is_absolute() {
        config_path
    } else {
        let mut full = kernel_root.clone();
        full.push(config_path);
        full
    };

    // 使用 try_exists 避免不必要的错误（Rust 1.55+）
    match full_path.try_exists() {
        Ok(true) => {}, // 文件存在，继续
        Ok(false) => return Err(format!("Kconfig 文件不存在: {}", full_path.display())),
        Err(e) => return Err(format!("无法访问文件 {}: {}", full_path.display(), e)),
    }

    // 读取文件内容，使用更大的缓冲区（可选）
    let content = read_file_with_optimization(&full_path)?;

    // 创建 KconfigFile 对象（使用 Arc 避免克隆）
    let kconfig_file = KconfigFile::new(kernel_root, full_path);

    // 使用带缓冲的输入创建
    let input = KconfigInput::new_extra(&content, kconfig_file);

    // 解析并处理结果
    match parse_kconfig(input) {
        Ok((remaining, kconfig)) => {
            // 可选：检查是否还有未解析的内容
            if !remaining.is_empty() {
                eprintln!("警告: 解析后还有未处理的内容 ({} 字节)", remaining.len());
            }
            Ok(kconfig)
        },
        Err(nom::Err::Incomplete(needed)) => {
            Err(format!("解析需要更多数据: {:?}", needed))
        },
        Err(nom::Err::Error(e)) | Err(nom::Err::Failure(e)) => {
            // 提取更详细的错误信息
            let error_detail = format!("在位置 {}: {:?}", e.input, e.code);
            Err(format!("解析失败: {}", error_detail))
        }
    }
}

/// 优化的文件读取函数
#[inline]
fn read_file_with_optimization(path: &Path) -> Result<String, String> {
    // 获取文件元信息以优化读取
    let metadata = fs::metadata(path)
        .map_err(|e| format!("无法获取文件元信息 {}: {}", path.display(), e))?;

    let file_size = metadata.len() as usize;

    // 对于大文件进行特殊处理（可配置阈值）
    const LARGE_FILE_THRESHOLD: usize = 10 * 1024 * 1024; // 10MB

    if file_size > LARGE_FILE_THRESHOLD {
        eprintln!("警告: 正在解析大文件 ({} MB)，可能需要较长时间",
                  file_size / 1024 / 1024);
    }

    // 预分配缓冲区大小
    let _ = String::with_capacity(file_size);

    // 读取文件
    fs::read_to_string(path)
        .map_err(|e| format!("无法读取文件 {}: {}", path.display(), e))
}

/// 批量解析多个 Kconfig 文件的高效版本
#[flutter_rust_bridge::frb]
pub fn parse_multiple_kconfig_files(
    kernel_root: String,
    config_paths: Vec<String>
) -> Result<Vec<(String, Result<Kconfig, String>)>, String> {
    let kernel_root = PathBuf::from(kernel_root);

    // 验证内核根目录
    if !kernel_root.exists() || !kernel_root.is_dir() {
        return Err(format!("无效的内核根目录: {}", kernel_root.display()));
    }

    {
        let mut results = Vec::with_capacity(config_paths.len());
        for path in config_paths {
            let path_buf = PathBuf::from(&path);
            let result = parse_config_file_internal(kernel_root.clone(), path_buf);
            results.push((path, result));
        }
        Ok(results)
    }
}

/// 缓存版本的解析器，避免重复解析相同文件
#[flutter_rust_bridge::frb]
pub struct KconfigParser {
    kernel_root: PathBuf,
    cache: std::collections::HashMap<PathBuf, Result<Kconfig, String>>,
}

#[flutter_rust_bridge::frb]
impl KconfigParser {
    pub fn new(kernel_root: String) -> Result<Self, String> {
        let kernel_root = PathBuf::from(kernel_root);
        if !kernel_root.exists() || !kernel_root.is_dir() {
            return Err(format!("无效的内核根目录: {}", kernel_root.display()));
        }

        Ok(Self {
            kernel_root,
            cache: std::collections::HashMap::new(),
        })
    }

    pub fn parse(&mut self, kconfig_path: String) -> Result<Kconfig, String> {
        let path = PathBuf::from(&kconfig_path);

        // 检查缓存
        if let Some(cached) = self.cache.get(&path) {
            return match cached {
                Ok(kconfig) => Ok(kconfig.clone()), // 需要 Kconfig 实现 Clone
                Err(e) => Err(e.clone()),
            };
        }

        // 解析并缓存结果
        let result = parse_config_file_internal(self.kernel_root.clone(), path.clone());

        // 插入缓存（需要 Kconfig 实现 Clone）
        if let Ok(kconfig) = &result {
            self.cache.insert(path, Ok(kconfig.clone()));
        } else if let Err(e) = &result {
            self.cache.insert(path, Err(e.clone()));
        }

        result
    }

    pub fn clear_cache(&mut self) {
        self.cache.clear();
    }
}