import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const String _prefsLocaleKey = 'selected_locale';

  static Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsLocaleKey, languageCode);
  }

  static Future<Locale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_prefsLocaleKey);
    if (languageCode == null) {
      return const Locale('en');
    }
    return Locale(languageCode);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      "app_version": "App Version 1.0.0",
      "reset": 'Reset',
      "No translation available yet. Start translating to see results":
          "No translation available yet. Start translating to see results",
      "Camera preview will appear here": "Camera preview will appear here",
      'profile_information': 'Profile Information',
      "Reset Password": "Reset Password",
      "We'll send you a reset link": "We'll send you a reset link",
      "Enter the email address associated with your account. We'll send you a link to reset your password.":
          "Enter the email address associated with your account. We'll send you a link to reset your password.",
      'send_reset_link': 'Send Reset Link',
      'back_to_login': 'Back to ',
      'successfully logged in': 'Successfully logged in',
      'successfully registered': 'Successfully registered',
      'successfully updated': 'Successfully updated',
      'successfully deleted': 'Successfully deleted',
      'Password must be at least 6 characters long':
          'Password must be at least 6 characters long',
      'Passwords do not match': 'Passwords do not match',
      'Please enter a password': 'Please enter a password',
      'Please confirm your password': 'Please confirm your password',
      'Please enter a valid 11-digit Egyptian phone number':
          'Please enter a valid 11-digit Egyptian phone number',
      'Please enter a valid email address':
          'Please enter a valid email address',
      'Please verify your email first': 'Please verify your email first',
      'Please enter your email': 'Please enter your email',
      'Please enter your password': 'Please enter your password',
      'Please enter your username': 'Please enter your username',
      'Please enter your name': 'Please enter your name',
      'Please enter your phone number': 'Please enter your phone number',
      'Welcome Back to Sign Wave': 'Welcome Back to Sign Wave',
      'Welcome to Sign Wave': 'Welcome to Sign Wave',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'Already have an account?': "Already have an account?",
      "create_account": "Create Account",
      "don't have an account?": "Don't have an account?",
      "sign up": "Sign up",
      'sign in': 'Sign in',
      "login": "Login",
      "forgot password?": "Forgot password?",
      'translation_result': 'Translation Result',
      'translation': 'Translation',
      'start': 'Start',
      'search': 'Search',
      'settings': 'Settings',
      'rest': 'Rest',
      'No_contacts_found': 'No contacts found',
      'No_recent_chats': 'No recent chats',
      'unknownUser': 'Unknown User',
      'translator': 'Translator',
      'chats': 'Chats',
      'contacts': 'Contacts',
      'calls': 'Calls',
      'profile': 'Profile',
      'edit_profile': 'Edit Profile',
      'save': 'Save',
      'save_profile': 'Save Profile',
      'cancel': 'Cancel',
      'sign_out': 'Sign Out',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
      'name': 'Name',
      'username': 'Username',
      'email': 'Email',
      'phone': 'Phone',
      'success': 'Success!',
      'profile_updated': 'Your profile has been updated successfully.',
      'error': 'Error',
      'user_not_logged_in': 'User not logged in',
      'message_options': 'Message options',
      'copy': 'Copy',
      'delete': 'Delete',
      'forward': 'Forward',
      'reply': 'Reply',
      'typing': 'typing',
      'online': 'Online',
      'last_seen_at': 'last seen at',
      'type_a_message': 'Type a message',
    },
    'ar': {
      "app_version": "1.0.0 نسخة التطبيق",
      "reset": 'إعادة تعيين',
      "No translation available yet. Start translating to see results":
          "لا توجد ترجمة متاحة بعد. ابدأ في الترجمة لرؤية النتائج",
      "Camera preview will appear here": "ستظهر معاينة الكاميرا هنا",
      'profile_information': 'معلومات الملف الشخصي',
      "Reset Password": "إعادة تعيين كلمة المرور",
      "We'll send you a reset link":
          " سنرسل لك رابط لإعادة تعيين كلمة المرور الخاصة بك.",
      "Enter the email address associated with your account. We'll send you a link to reset your password.":
          "أدخل عنوان بريدك الإلكتروني المرتبط بالحساب. سنرسل لك رابط لإعادة تعيين كلمة المرور الخاصة بك.",
      'send_reset_link': 'إرسال رابط إعادة تعيين كلمة المرور',
      'back_to_login': 'العودة إلى ',
      'successfully logged in': 'تم تسجيل الدخول بنجاح',
      'successfully registered': 'تم التسجيل بنجاح',
      'successfully updated': 'تم تحديث الملف الشخصي بنجاح',
      'successfully deleted': 'تم حذف الملف الشخصي بنجاح',
      'successfully logged out': 'تم تسجيل الخروج بنجاح',
      'Password must be at least 6 characters long':
          'كلمة المرور يجب أن تكون على الأقل 6 أحرف',
      'Passwords do not match': 'كلمات المرور غير متطابقتان',
      'Please enter a password': 'الرجاء إدخال كلمة المرور',
      'Please confirm your password': 'الرجاء تأكيد كلمة المرور',
      'Please enter a valid 11-digit Egyptian phone number':
          'الرجاء إدخال رقم هاتف 11 أرقام مصرى صالح',
      'Please enter a valid email address':
          'الرجاء إدخال عنوان بريد إلكتروني صالح',
      'Please verify your email first':
          'الرجاء التحقق من بريدك الإلكتروني أولاً',
      'Please enter your email': 'الرجاء إدخال بريدك الإلكتروني',
      'Please enter your password': 'الرجاء إدخال كلمة المرور',
      'Please enter your username': 'الرجاء إدخال اسم المستخدم',
      'Please enter your name': 'الرجاء إدخال الاسم',
      'Please enter your phone number': 'الرجاء إدخال رقم الهاتف',
      'Welcome Back to Sign Wave': 'مرحبًا بعودتك إلى Sign Wave',
      'Welcome to Sign Wave': 'مرحبًا بك في Sign Wave',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'sign in': 'تسجيل الدخول',
      'Already have an account?': "هل لديك حساب بالفعل؟",
      "create_account": "إنشاء حساب جديد",
      "login": "تسجيل الدخول",
      "sign up": "تسجيل حساب جديد",
      "forgot password?": "هل نسيت كلمة المرور؟",
      "don't have an account?": "ليس لديك حساب؟",
      'translation_result': 'نتيجة الترجمة',
      'translation': 'الترجمة',
      'start': 'بدء',
      'search': 'بحث',
      'rest': 'استراحة',
      'No_contacts_found': 'لم يتم العثور على جهات الاتصال',
      'No_recent_chats': 'لا توجد محادثات مؤخرة',
      'Unknown User': 'مستخدم غير معروف',
      'translator': 'مترجم',
      'chats': 'المحادثات',
      'contacts': 'الجهات الاتصال',
      'calls': 'الاستدعاءات',
      'profile': 'الملف الشخصي',
      'edit_profile': 'تعديل الملف الشخصي',
      'save': 'حفظ',
      'save_profile': 'حفظ الملف الشخصي',
      'cancel': 'إلغاء',
      'sign_out': 'تسجيل الخروج',
      'dark_mode': 'الوضع المظلم',
      'light_mode': 'الوضع المضيء',
      'language': 'اللغة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'name': 'الاسم',
      'username': 'اسم المستخدم',
      'email': 'البريد الإلكتروني',
      'phone': 'الهاتف',
      'success': 'تم بنجاح!',
      'profile_updated': 'تم تحديث الملف الشخصي بنجاح.',
      'error': 'خطأ',
      'user_not_logged_in': 'المستخدم غير مسجل الدخول',
      'settings': 'الإعدادات',
      'message_options': 'خيارات الرسالة',
      'copy': 'نسخ',
      'delete': 'حذف',
      'forward': 'إعادة توجيه',
      'reply': 'رد',
      'typing': 'يكتب',
      'online': 'متصل',
      'last_seen_at': 'آخر ظهور في',
      'type_a_message': 'اكتب رسالة',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Extension to make it easier to access translations
extension TranslateX on BuildContext {
  String tr(String key) => AppLocalizations.of(this).translate(key);
}
