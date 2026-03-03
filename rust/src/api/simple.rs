use nom_kconfig::{parse_kconfig, KconfigFile, KconfigInput};
use std::fs;
use std::path::PathBuf;
use serde_json;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

#[flutter_rust_bridge::frb]
pub fn get_kernel_config_ast(
    kernel_root: String,
    config_path: String,
) -> Result<String, String> {
    let kernel_root = PathBuf::from(kernel_root);
    let config_path = PathBuf::from(config_path);

    let full_path = if config_path.is_absolute() {
        config_path
    } else {
        kernel_root.join(config_path)
    };

    let content = match fs::read_to_string(&full_path) {
        Ok(c) => c,
        Err(e) => return Err(format!("读取文件失败: {}", e)),
    };

    let config_file = KconfigFile::new(kernel_root, full_path);
    let input = KconfigInput::new_extra(&content, config_file);

    match parse_kconfig(input) {
        Ok((_, config)) => {
            // ✅ 将结构体序列化为 JSON 字符串
            match serde_json::to_string(&config) {
                Ok(json_str) => Ok(json_str),
                Err(e) => Err(format!("JSON 序列化失败: {}", e)),
            }
        },
        Err(e) => Err(format!("解析失败: {:?}", e)),
    }
}