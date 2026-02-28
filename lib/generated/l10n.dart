// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Initializing system...`
  String get initSystem {
    return Intl.message(
      'Initializing system...',
      name: 'initSystem',
      desc: '',
      args: [],
    );
  }

  /// `Initialize`
  String get initButton {
    return Intl.message('Initialize', name: 'initButton', desc: '', args: []);
  }

  /// `kernel_config`
  String get appTitle {
    return Intl.message('kernel_config', name: 'appTitle', desc: '', args: []);
  }

  /// `Welcome to kernel_config`
  String get welcome {
    return Intl.message(
      'Welcome to kernel_config',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Enter card code`
  String get cardCodeLabel {
    return Intl.message(
      'Enter card code',
      name: 'cardCodeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter card code`
  String get cardCodeHint {
    return Intl.message(
      'Please enter card code',
      name: 'cardCodeHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter bind code`
  String get bindCodeLabel {
    return Intl.message(
      'Enter bind code',
      name: 'bindCodeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter bind code`
  String get bindCodeHint {
    return Intl.message(
      'Please enter bind code',
      name: 'bindCodeHint',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginButton {
    return Intl.message('Login', name: 'loginButton', desc: '', args: []);
  }

  /// `Login Successful!`
  String get loginSuccess {
    return Intl.message(
      'Login Successful!',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Login failed, please check your codes`
  String get loginFailed {
    return Intl.message(
      'Login failed, please check your codes',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Kernel Config Tool`
  String get welcomeToUse {
    return Intl.message(
      'Welcome to Kernel Config Tool',
      name: 'welcomeToUse',
      desc: '',
      args: [],
    );
  }

  /// `Current language: {language}`
  String currentLanguage(String language) {
    return Intl.message(
      'Current language: $language',
      name: 'currentLanguage',
      desc: 'Displays the current language',
      args: [language],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
