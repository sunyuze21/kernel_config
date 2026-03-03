// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get back => '返回';

  @override
  String get error_bind_code => '绑定码错误！';

  @override
  String get error_no_kami => '卡密不存在!';

  @override
  String get initSystem => '正在初始化系统...';

  @override
  String get initButton => '初始化';

  @override
  String get appTitle => 'kernel_config';

  @override
  String get welcome => 'kernel_config欢迎您';

  @override
  String get cardCodeLabel => '请输入卡密';

  @override
  String get cardCodeHint => '请输入卡密';

  @override
  String get bindCodeLabel => '请输入绑定码';

  @override
  String get bindCodeHint => '请输入绑定码';

  @override
  String get loginButton => '登录';

  @override
  String get loginSuccess => '登录成功';

  @override
  String get loginFailed => '登录失败，请检查您的卡密';

  @override
  String get welcomeToUse => '欢迎使用 Kernel Config 工具';

  @override
  String currentLanguage(String language) {
    return '当前语言：$language';
  }
}
