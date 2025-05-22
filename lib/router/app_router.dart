import 'package:flutter/material.dart';
import 'package:sign_wave_v3/main.dart';

class AppRouter {
  // Use the global navigatorKey instead of creating a new one
  NavigatorState get _navigator => navigatorKey.currentState!;

  void pop<T>([T? result]) {
    return _navigator.pop(result);
  }

  Future<T?> push<T>(Widget page) {
    return _navigator.push<T>(MaterialPageRoute(builder: (_) => page));
  }

  Future<T?> pushReplacement<T>(Widget page) {
    return _navigator.pushReplacement<T, dynamic>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return _navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return _navigator.pushNamed<T>(routeName, arguments: arguments);
  }
}
