import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvHelper {
  /// Get a string value from the .env file.
  static String getString(String key, {String? defaultValue}) {
    final value = dotenv.env[key];
    return value ?? defaultValue ?? '';
  }

  /// Get a boolean value from the .env file.
  static bool getBool(String key, {bool defaultValue = false}) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) return defaultValue;
    return value.toLowerCase() == 'true';
  }

  /// Get an integer value from the .env file.
  static int getInt(String key, {int defaultValue = 0}) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }
}