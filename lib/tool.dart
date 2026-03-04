import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ToolPage extends StatefulWidget {
  const ToolPage({super.key});

  @override
  State<ToolPage> createState() => _ToolPageState();
}

class _ToolPageState extends State<ToolPage> {
  // 存储选择的路径
  String? _kernelPath;
  String? _kconfigPath;

  // 加载状态
  bool _isSelectingKernel = false;
  bool _isSelectingKconfig = false;

  // 选择内核根目录
  Future<void> _selectKernelPath() async {
    setState(() {
      _isSelectingKernel = true;
    });

    try {
      // 选择目录
      String? selectedPath = await FilePicker.platform.getDirectoryPath(
        dialogTitle: '请选择内核根目录',
        lockParentWindow: true, // 锁定父窗口
      );

      if (selectedPath != null) {
        setState(() {
          _kernelPath = selectedPath;
        });

        // 显示成功提示
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('已选择内核目录: ${_getShortPath(selectedPath)}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // 处理错误
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('选择失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSelectingKernel = false;
        });
      }
    }
  }

  // 选择kconfig文件
  Future<void> _selectKconfigFile() async {
    setState(() {
      _isSelectingKconfig = true;
    });

    try {
      // 选择文件，限制为.config或Kconfig相关文件
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: '请选择kconfig文件',
        type: FileType.any,
        allowMultiple: false,
        lockParentWindow: true,
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.first.path;
        if (filePath != null) {
          setState(() {
            _kconfigPath = filePath;
          });

          // 显示成功提示
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('已选择内核配置文件: ${result.files.first.name}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('选择失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSelectingKconfig = false;
        });
      }
    }
  }

  // 简化长路径显示
  String _getShortPath(String path, {int maxLength = 30}) {
    if (path.length <= maxLength) return path;
    return '...${path.substring(path.length - maxLength)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            const Text(
              '请选择内核相关文件',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 第一个按钮：选择内核根目录
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isSelectingKernel ? null : _selectKernelPath,
                            icon: _isSelectingKernel
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                                : const Icon(Icons.folder_open),
                            label: Text(
                              _isSelectingKernel ? '选择中...' : '选择内核根目录',
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_kernelPath != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle,
                                color: Colors.green,
                                size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _getShortPath(_kernelPath!),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear, size: 16),
                              onPressed: () {
                                setState(() {
                                  _kernelPath = null;
                                });
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 第二个按钮：选择kconfig文件
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isSelectingKconfig ? null : _selectKconfigFile,
                            icon: _isSelectingKconfig
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                                : const Icon(Icons.description),
                            label: Text(
                              _isSelectingKconfig ? '选择中...' : '选择kconfig文件',
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_kconfigPath != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle,
                                color: Colors.green,
                                size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _getShortPath(_kconfigPath!),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear, size: 16),
                              onPressed: () {
                                setState(() {
                                  _kconfigPath = null;
                                });
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 确认按钮
            Center(
              child: ElevatedButton(
                onPressed: (_kernelPath == null || _kconfigPath == null)
                    ? null
                    : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '内核目录: ${_getShortPath(_kernelPath!)}\n'
                            'Kconfig文件: ${_getShortPath(_kconfigPath!)}',
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  // 这里可以添加你的处理逻辑
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('解析'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}