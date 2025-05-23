import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../localization/app_localizations.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  final SharedPreferences _prefs;
  static const String _localeKey = 'selected_locale';

  LocalizationCubit({required SharedPreferences prefs})
      : _prefs = prefs,
        super(LocalizationState(
          locale: Locale(prefs.getString(_localeKey) ?? 'en'),
        )) {
    // Initialize locale from saved preferences
    final savedLocale = _prefs.getString(_localeKey);
    if (savedLocale != null) {
      emit(LocalizationState(locale: Locale(savedLocale)));
    }
  }

  /// Toggle between English and Arabic
  void toggleLocale() {
    final newLocale = state.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
    _saveLocalePreference(newLocale.languageCode);
    emit(LocalizationState(locale: newLocale));
  }

  /// Set a specific locale
  void setLocale(String languageCode) {
    _saveLocalePreference(languageCode);
    emit(LocalizationState(locale: Locale(languageCode)));
  }

  /// Save locale preference to shared preferences
  void _saveLocalePreference(String languageCode) {
    _prefs.setString(_localeKey, languageCode);
    AppLocalizations.setLocale(languageCode);
  }
}