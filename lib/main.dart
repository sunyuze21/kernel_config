import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

// 状态管理组件：用于控制语言切换
class KernelConfigApp extends StatefulWidget {
  const KernelConfigApp({super.key});

  @override
  State<KernelConfigApp> createState() => _KernelConfigAppState();
}

class _KernelConfigAppState extends State<KernelConfigApp> {
  // 默认语言
  Locale _currentLocale = const Locale('zh');

  // 切换语言的方法
  void _setLocale(Locale locale) {
    setState(() {
      _currentLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kernel_config',
      locale: _currentLocale, // 绑定状态
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh'),
        Locale('en'),
      ],
      home: HomePage(
        currentLocale: _currentLocale,
        onLocaleChanged: _setLocale,
      ),
    );
  }
}

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
          // 🌍 地球图标按钮
          PopupMenuButton<Locale>(
            icon: const Icon(
              Icons.language,
              color: Colors.white,
              size: 26,
            ),
            tooltip: 'Switch Language',
            // 构建菜单项
            itemBuilder: (context) => [
              // 中文选项
              PopupMenuItem(
                value: const Locale('zh'),
                enabled: currentLocale.languageCode != 'zh', // 当前语言禁用
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
              // 英文选项
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
            // 点击选项后的回调
            onSelected: (locale) {
              onLocaleChanged(locale);
            },
          ),
          const SizedBox(width: 10), // 右侧留白
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LoginInput(),
        ),
      ),
      // 底部显示当前语言提示
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

class LoginInput extends StatelessWidget {
  const LoginInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          height: 60,
          child: TextField(
            decoration: InputDecoration(
              labelText: l10n.cardCodeLabel,
              hintText: l10n.cardCodeHint,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          height: 60,
          child: TextField(
            decoration: InputDecoration(
              labelText: l10n.bindCodeLabel,
              hintText: l10n.bindCodeHint,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (kDebugMode) {
                print(l10n.loginSuccess);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              l10n.loginButton,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}