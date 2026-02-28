// lib/pages/tool_page.dart
import 'package:flutter/material.dart';

class ToolPage extends StatelessWidget {
  const ToolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('工具页')),
      body: const Center(child: Text('欢迎来到工具页！')),
    );
  }
}
