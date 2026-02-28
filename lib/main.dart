The original content is temporarily commented out to allow generating a self-contained demo - feel free to uncomment later.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kernel_config/Login.dart'; // 确保你的登录页文件路径正确
import 'package:kernel_config/tool.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const KernelConfig());
}

class KernelConfig extends StatelessWidget {
  const KernelConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return const KernelConfigApp();
  }
}

class KernelConfigApp extends StatefulWidget {
  const KernelConfigApp({super.key});

  @override
  State<KernelConfigApp> createState() => _KernelConfigAppState();
}

class _KernelConfigAppState extends State<KernelConfigApp> {
  Locale _currentLocale = const Locale('zh');

  void _setLocale(Locale locale) {
    setState(() {
      _currentLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kernel_config',
      debugShowCheckedModeBanner: false,
      locale: _currentLocale,
      routes: {
        '/login': (context) => const LoginPage(),
        '/tool': (context) => const ToolPage(), // 确保 ToolPage 在 tool.dart 中已定义
        // 如果有其他页面，继续在这里添加
        // '/settings': (context) => const SettingsPage(),
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh'), Locale('en')],
      home: HomePage(
        currentLocale: _currentLocale,
        onLocaleChanged: _setLocale,
      ),
    );
  }
}

// ================= HomePage =================
class HomePage extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;

  const HomePage({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.welcome),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language, color: Colors.white, size: 26),
            tooltip: 'Switch Language',
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('zh'),
                enabled: currentLocale.languageCode != 'zh',
                child: Row(
                  children: [
                    if (currentLocale.languageCode == 'zh')
                      const Icon(Icons.check, color: Colors.blue, size: 20),
                    if (currentLocale.languageCode != 'zh')
                      const SizedBox(width: 20),
                    const Text('简体中文'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: const Locale('en'),
                enabled: currentLocale.languageCode != 'en',
                child: Row(
                  children: [
                    if (currentLocale.languageCode == 'en')
                      const Icon(Icons.check, color: Colors.blue, size: 20),
                    if (currentLocale.languageCode != 'en')
                      const SizedBox(width: 20),
                    const Text('English'),
                  ],
                ),
              ),
            ],
            onSelected: (locale) {
              onLocaleChanged(locale);
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: InitPage(
            onInitComplete: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Center(
          child: Text(
            l10n.currentLanguage(
              currentLocale.languageCode == 'zh' ? '简体中文' : 'English',
            ),
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

// ================= InitPage =================
class InitPage extends StatefulWidget {
  final VoidCallback onInitComplete;

  const InitPage({super.key, required this.onInitComplete});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  bool _isLoading = false;
  String? _errorMessage;

  // 【核心修改】处理按钮点击：调用返回 bool 的 init 函数
  Future<void> _handleInit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. 调用你的初始化函数 (必须返回 Future<bool>)
      // 请将下面的 initSystem() 替换为你实际调用的函数
      final success = await initSystem();

      if (success) {
        if (kDebugMode) {
          print("✅ 初始化成功，准备跳转...");
        }

        // 可选：稍微延迟一点，让成功状态更自然
        await Future.delayed(const Duration(milliseconds: 300));

        // 2. 成功后执行回调 (跳转)
        if (mounted) {
          widget.onInitComplete();
        }
      } else {
        // 3. 返回 false 的情况
        if (kDebugMode) {
          print("⚠️ 初始化返回 false");
        }
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = "初始化验证失败 (返回 false)";
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("初始化失败，请检查设备或网络"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      // 4. 捕获异常
      print("❌ 初始化发生异常: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("初始化错误: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              "❌ $_errorMessage",
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

        if (_isLoading)
          Column(
            children: [
              const CircularProgressIndicator(color: Colors.blue, strokeWidth: 4),
              const SizedBox(height: 16),
              Text(
                l10n.initSystem,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          )
        else
          SizedBox(
            width: 300,
            height: 50,
            child: ElevatedButton(
              onPressed: _handleInit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                l10n.initButton,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
      ],
    );
  }
}

// ============================================================
// 【重要】请在这里实现或导入你真实的 initSystem 函数
// 它必须返回 Future<bool>
// ============================================================

/// 模拟初始化函数
/// 真实场景中，请删除此函数，并导入你实际的业务逻辑函数
Future<bool> initSystem() async {
  return true; // 默认返回成功
}


