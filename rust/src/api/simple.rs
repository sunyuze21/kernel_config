// native/src/api.rs
use nom_kconfig::{parse_kconfig, Kconfig, KconfigFile, KconfigInput};
use std::fs;
use std::path::PathBuf;

/// 初始化函数（框架需要）
#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}


#[flutter_rust_bridge::frb]
pub fn get_kernel_config_ast(
    kernel_root: String,
    config_path: String,
) -> Result<Kconfig, String> {
    // 1. 构建完整路径
    let kernel_root = PathBuf::from(kernel_root);
    let config_path = PathBuf::from(config_path);

    let full_path = if config_path.is_absolute() {
        config_path
    } else {
        kernel_root.join(config_path)
    };

    // 2. 读取文件
    let content = match fs::read_to_string(&full_path) {
        Ok(c) => c,
        Err(e) => return Err(format!("读取文件失败: {}", e)),
    };

    // 3. 解析
    let config_file = KconfigFile::new(kernel_root, full_path);
    let input = KconfigInput::new_extra(&content, config_file);

    match parse_kconfig(input) {
        Ok((_, config)) => Ok(config),
        Err(e) => Err(format!("解析失败: {:?}", e)),
    }
}