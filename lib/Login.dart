import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kernel_config/func/login.dart';
import 'l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/main');
          },
          tooltip: l10n.back, // 如果需要本地化的返回提示
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: LoginInput(),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Center(
          child: Text(
            l10n.currentLanguage(
              Localizations.localeOf(context).languageCode == 'zh'
                  ? '简体中文'
                  : 'English',
            ),
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class LoginInput extends StatefulWidget {
  const LoginInput({super.key});

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  late final TextEditingController _cardController;
  late final TextEditingController _bindController;

  @override
  void initState() {
    super.initState();
    _cardController = TextEditingController();
    _bindController = TextEditingController();
  }

  @override
  void dispose() {
    _cardController.dispose();
    _bindController.dispose();
    super.dispose();
  }

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
            controller: _cardController,
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
            controller: _bindController,
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
            onPressed: () async {
              String kami = _cardController.text;
              String bind = _bindController.text;

              try {
                var res = await Login(kami, bind);
                if (!res.startsWith('-')) {
                  if (kDebugMode) {
                    print("登录成功: $res");
                  }
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, '/tool');
                  }
                } else {
                  // 处理返回错误码的情况
                  if (kDebugMode) {
                    print("登录失败，错误码: $res");
                  }
                  var ress = '未知错误！';
                  if (res.startsWith('-83001') || res.startsWith('-83002')) {
                    ress = l10n.error_no_kami;
                  }
                  if (res.startsWith('-83008')) {
                    ress =l10n.error_bind_code;
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("登录失败: $ress"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } catch (e) {
                // 【修改点 3】修复变量名 e，并修正日志内容
                if (kDebugMode) {
                  print("登录异常: $e");
                }
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("发生错误: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.loginButton, style: const TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}