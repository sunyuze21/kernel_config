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

// 【修改点 1】改为 StatefulWidget
class LoginInput extends StatefulWidget {
  const LoginInput({super.key});

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  // 【修改点 2】控制器移到这里，作为状态成员变量
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
    // 【重要】释放控制器，防止内存泄漏
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

                // 检查是否以 '-' 开头 (假设 '-' 代表错误码)
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
                  var ress='未知错误！';
                  if(res.startsWith('-83001') || res.startsWith('-83002')){
                    ress='卡密不存在！';
                  }
                  if(res.startsWith('-83008')){
                    ress='绑定码错误！！';
                  }
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("登录失败: $ress"), backgroundColor: Colors.red),
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
                    SnackBar(content: Text("发生错误: $e"), backgroundColor: Colors.red),
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