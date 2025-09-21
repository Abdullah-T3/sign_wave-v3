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
      "about_app": "About the App",
      "about_app_description_1":
          "Sign Wave Translator is an innovative mobile application designed to break down communication barriers between the deaf community and hearing individuals. Our app combines cutting-edge technology with user-friendly design to create a seamless sign language translation experience.",
      "about_app_description_2":
          "Using advanced computer vision and machine learning algorithms, Sign Wave Translator can interpret sign language gestures in real-time, converting them into text that can be easily understood by anyone. The app also supports text-to-sign language translation, making it a powerful two-way communication tool.",
      "about_app_description_3":
          "Whether you're a member of the deaf community, a sign language learner, or someone who frequently interacts with deaf individuals, Sign Wave Translator provides an accessible and efficient way to communicate effectively.",
      "features": "Features",
      "feature_realtime_messaging": "Real-time messaging",
      "feature_sign_language": "Sign language translation",
      "feature_user_friendly": "User-friendly interface",
      "feature_secure_auth": "Secure authentication",
      "contact_us": "Contact Us",
      "contact_us_description": "For support or feedback, please contact us at",
      "copyright": "© 2024 Sign Wave Translator. All rights reserved.",
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
      'welcome_back': 'Welcome Back!',
      'sign_in_to_continue': 'Sign in to continue to your account',
      'email_address': 'Email Address',
      'full_name': 'Full Name',
      'phone_number': 'Phone Number',
      'dont_worry_reset':
          "Don't worry! Enter your email address and we'll send you a link to reset your password.",
      'remember_password': 'Remember your password?',
      'join_us_journey': 'Join us and start your journey',
      'already_have_account': "Already have an account?",
      'dont_have_account': "Don't have an account?",
      'login_failed': 'Login Failed',
      'sign_up_failed': 'Sign Up Failed',
      'email_verification_required': 'Email Verification Required',
      'verify_email_before_signin':
          'Please verify your email before signing in',
      'login_success': 'Login success',
      'account_created_successfully': 'Account Created Successfully',
      'check_email_verify_account':
          'Please check your email and verify your account to complete the sign up process',
      'error_occurred_login': 'An error occurred during login',
      'error_occurred_signup': 'An error occurred during sign up',
      'error_occurred_reset': 'An error occurred while sending reset email',
      'reset_email_sent': 'Reset Email Sent',
      'check_email_reset_instructions':
          'Please check your email for password reset instructions',
      'please_enter_email_address': 'Please enter your email address',
      'please_enter_valid_email_example':
          'Please enter a valid email address (e.g., example@email.com)',
      'OR': 'OR',
      // Error Messages
      'error_invalid_email': 'Please enter a valid email address',
      'error_user_disabled':
          'Your account has been disabled. Please contact support',
      'error_user_not_found': 'No account found with this email address',
      'error_wrong_password': 'Incorrect password. Please try again',
      'error_email_already_in_use': 'An account with this email already exists',
      'error_operation_not_allowed': 'This action is not allowed at the moment',
      'error_weak_password':
          'Password is too weak. Please choose a stronger password',
      'error_network_request_failed':
          'Network error. Please check your internet connection',
      'error_too_many_requests':
          'Too many failed attempts. Please wait a moment and try again',
      'error_invalid_credential':
          'Invalid login credentials. Please check your email and password',
      'error_account_exists_different_credential':
          'An account with this email exists but uses different sign-in method',
      'error_invalid_verification_code': 'Invalid verification code',
      'error_invalid_verification_id': 'Invalid verification ID',
      'error_invalid_action_code': 'Invalid action code',
      'error_invalid_continue_uri': 'Invalid continue URI',
      'error_invalid_dynamic_link_domain': 'Invalid dynamic link domain',
      'error_general': 'Something went wrong. Please try again',
      'error_signup_failed': 'Failed to create account. Please try again',
      'error_signin_failed': 'Failed to sign in. Please check your credentials',
      'error_signout_failed': 'Failed to sign out. Please try again',
      'error_password_reset_failed': 'Failed to send password reset email',
      'error_user_data_not_found':
          'User data not found. Please contact support',
      'error_email_already_exists': 'An account with this email already exists',
      'error_phone_already_exists':
          'An account with this phone number already exists',
      'error_username_already_exists': 'This username is already taken',
      'error_save_user_data_failed':
          'Failed to save user data. Please try again',
      'error_update_user_data_failed':
          'Failed to update user data. Please try again',
      'error_delete_account_failed':
          'Failed to delete account. Please try again',
      'error_delete_user_data_failed':
          'Failed to delete user data. Please try again',
      'error_no_user_signed_in': 'No user is currently signed in',
      'error_email_not_verified':
          'Please verify your email address before signing in',
      'error_verification_email_sent':
          'Verification email has been sent to your inbox',
    },
    'ar': {
      "app_version": "1.0.0 نسخة التطبيق",
      "about_app": "عن التطبيق",
      "about_app_description_1":
          "Sign Wave Translator هو تطبيق جوال مبتكر مصمم لكسر حواجز التواصل بين مجتمع الصم والأفراد السامعين. يجمع تطبيقنا بين التكنولوجيا المتطورة والتصميم سهل الاستخدام لخلق تجربة ترجمة لغة الإشارة سلسة.",
      "about_app_description_2":
          "باستخدام خوارزميات رؤية الكمبيوتر المتقدمة وتعلم الآلة، يمكن لـ Sign Wave Translator تفسير إيماءات لغة الإشارة في الوقت الفعلي، وتحويلها إلى نص يمكن فهمه بسهولة من قبل أي شخص. كما يدعم التطبيق الترجمة من النص إلى لغة الإشارة، مما يجعله أداة تواصل قوية في كلا الاتجاهين.",
      "about_app_description_3":
          "سواء كنت من مجتمع الصم، أو متعلم لغة الإشارة، أو شخصًا يتفاعل بشكل متكرر مع الأفراد الصم، يوفر Sign Wave Translator طريقة سهلة وفعالة للتواصل.",
      "features": "المميزات",
      "feature_realtime_messaging": "المراسلة في الوقت الفعلي",
      "feature_sign_language": "ترجمة لغة الإشارة",
      "feature_user_friendly": "واجهة سهلة الاستخدام",
      "feature_secure_auth": "مصادقة آمنة",
      "contact_us": "اتصل بنا",
      "contact_us_description":
          "للحصول على الدعم أو إرسال ملاحظات، يرجى الاتصال بنا على",
      "copyright": "© 2024 Sign Wave Translator. جميع الحقوق محفوظة.",
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
      'welcome_back': 'مرحبًا بعودتك!',
      'sign_in_to_continue': 'سجل الدخول للمتابعة إلى حسابك',
      'email_address': 'عنوان البريد الإلكتروني',
      'full_name': 'الاسم الكامل',
      'phone_number': 'رقم الهاتف',
      'dont_worry_reset':
          'لا تقلق! أدخل عنوان بريدك الإلكتروني وسنرسل لك رابط لإعادة تعيين كلمة المرور.',
      'remember_password': 'هل تتذكر كلمة المرور؟',
      'join_us_journey': 'انضم إلينا وابدأ رحلتك',
      'already_have_account': 'هل لديك حساب بالفعل؟',
      'dont_have_account': 'ليس لديك حساب؟',
      'login_failed': 'فشل تسجيل الدخول',
      'sign_up_failed': 'فشل إنشاء الحساب',
      'email_verification_required': 'التحقق من البريد الإلكتروني مطلوب',
      'verify_email_before_signin':
          'يرجى التحقق من بريدك الإلكتروني قبل تسجيل الدخول',
      'login_success': 'تم تسجيل الدخول بنجاح',
      'account_created_successfully': 'تم إنشاء الحساب بنجاح',
      'check_email_verify_account':
          'يرجى التحقق من بريدك الإلكتروني والتحقق من حسابك لإكمال عملية التسجيل',
      'error_occurred_login': 'حدث خطأ أثناء تسجيل الدخول',
      'error_occurred_signup': 'حدث خطأ أثناء إنشاء الحساب',
      'error_occurred_reset': 'حدث خطأ أثناء إرسال بريد إعادة التعيين',
      'reset_email_sent': 'تم إرسال بريد إعادة التعيين',
      'check_email_reset_instructions':
          'يرجى التحقق من بريدك الإلكتروني للحصول على تعليمات إعادة تعيين كلمة المرور',
      'please_enter_email_address': 'يرجى إدخال عنوان بريدك الإلكتروني',
      'please_enter_valid_email_example':
          'يرجى إدخال عنوان بريد إلكتروني صالح (مثال: example@email.com)',
      'OR': 'أو',
      // Error Messages
      'error_invalid_email': 'يرجى إدخال عنوان بريد إلكتروني صالح',
      'error_user_disabled': 'تم تعطيل حسابك. يرجى الاتصال بالدعم',
      'error_user_not_found': 'لم يتم العثور على حساب بهذا البريد الإلكتروني',
      'error_wrong_password': 'كلمة مرور غير صحيحة. يرجى المحاولة مرة أخرى',
      'error_email_already_in_use': 'يوجد حساب بهذا البريد الإلكتروني بالفعل',
      'error_operation_not_allowed': 'هذا الإجراء غير مسموح في الوقت الحالي',
      'error_weak_password':
          'كلمة المرور ضعيفة جداً. يرجى اختيار كلمة مرور أقوى',
      'error_network_request_failed':
          'خطأ في الشبكة. يرجى التحقق من اتصال الإنترنت',
      'error_too_many_requests':
          'محاولات فاشلة كثيرة. يرجى الانتظار قليلاً والمحاولة مرة أخرى',
      'error_invalid_credential':
          'بيانات تسجيل الدخول غير صحيحة. يرجى التحقق من البريد الإلكتروني وكلمة المرور',
      'error_account_exists_different_credential':
          'يوجد حساب بهذا البريد الإلكتروني ولكن يستخدم طريقة تسجيل دخول مختلفة',
      'error_invalid_verification_code': 'رمز التحقق غير صحيح',
      'error_invalid_verification_id': 'معرف التحقق غير صحيح',
      'error_invalid_action_code': 'رمز الإجراء غير صحيح',
      'error_invalid_continue_uri': 'رابط المتابعة غير صحيح',
      'error_invalid_dynamic_link_domain': 'نطاق الرابط الديناميكي غير صحيح',
      'error_general': 'حدث خطأ ما. يرجى المحاولة مرة أخرى',
      'error_signup_failed': 'فشل في إنشاء الحساب. يرجى المحاولة مرة أخرى',
      'error_signin_failed': 'فشل في تسجيل الدخول. يرجى التحقق من بياناتك',
      'error_signout_failed': 'فشل في تسجيل الخروج. يرجى المحاولة مرة أخرى',
      'error_password_reset_failed':
          'فشل في إرسال بريد إعادة تعيين كلمة المرور',
      'error_user_data_not_found':
          'لم يتم العثور على بيانات المستخدم. يرجى الاتصال بالدعم',
      'error_email_already_exists': 'يوجد حساب بهذا البريد الإلكتروني بالفعل',
      'error_phone_already_exists': 'يوجد حساب بهذا رقم الهاتف بالفعل',
      'error_username_already_exists': 'اسم المستخدم هذا مستخدم بالفعل',
      'error_save_user_data_failed':
          'فشل في حفظ بيانات المستخدم. يرجى المحاولة مرة أخرى',
      'error_update_user_data_failed':
          'فشل في تحديث بيانات المستخدم. يرجى المحاولة مرة أخرى',
      'error_delete_account_failed':
          'فشل في حذف الحساب. يرجى المحاولة مرة أخرى',
      'error_delete_user_data_failed':
          'فشل في حذف بيانات المستخدم. يرجى المحاولة مرة أخرى',
      'error_no_user_signed_in': 'لا يوجد مستخدم مسجل الدخول حالياً',
      'error_email_not_verified':
          'يرجى التحقق من عنوان بريدك الإلكتروني قبل تسجيل الدخول',
      'error_verification_email_sent':
          'تم إرسال بريد التحقق إلى صندوق الوارد الخاص بك',
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
