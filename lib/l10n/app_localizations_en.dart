// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'kernel_config';

  @override
  String get welcome => 'Welcome to kernel_config';

  @override
  String get cardCodeLabel => 'Enter card code';

  @override
  String get cardCodeHint => 'Please enter card code';

  @override
  String get bindCodeLabel => 'Enter bind code';

  @override
  String get bindCodeHint => 'Please enter bind code';

  @override
  String get loginButton => 'Login';

  @override
  String get loginSuccess => 'Login Successful!';

  @override
  String get loginFailed => 'Login failed, please check your codes';

  @override
  String get welcomeToUse => 'Welcome to Kernel Config Tool';

  @override
  String currentLanguage(String language) {
    return 'Current language: $language';
  }
}
