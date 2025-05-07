import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'United Hope',
      'welcome': 'Welcome',
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'forgotPassword': 'Forgot Password?',
      'donate': 'Donate',
      'requests': 'Requests',
      'profile': 'Profile',
    },
    'ar': {
      'appTitle': 'الأمل المتحد',
      'welcome': 'مرحبا',
      'login': 'تسجيل الدخول',
      'register': 'تسجيل',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'forgotPassword': 'نسيت كلمة المرور؟',
      'donate': 'تبرع',
      'requests': 'الطلبات',
      'profile': 'الملف الشخصي',
    },
    'fr': {
      'appTitle': 'Espoir Unis',
      'welcome': 'Bienvenue',
      'login': 'Connexion',
      'register': 'Enregistrer',
      'email': 'E-mail',
      'password': 'Mot de passe',
      'forgotPassword': 'Mot de passe oublié?',
      'donate': 'Faire un don',
      'requests': 'Demandes',
      'profile': 'Profil',
    },
  };

  String translate(String key) {
    try {
      return _localizedValues[locale.languageCode]![key] ??
          _localizedValues['en']![key] ??
          key;
    } catch (e) {
      if (kDebugMode) {
        print('Localization key "$key" not found for ${locale.languageCode}');
      }
      return key;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizationExtension on BuildContext {
  String translate(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
}
