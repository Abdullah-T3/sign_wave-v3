import 'package:flutter/material.dart';

import '../../features/home/data/repo/chat_repository.dart';

class AppLifeCycleObserver extends WidgetsBindingObserver {
  final String userId;
  final ChatRepository chatRepository;

  AppLifeCycleObserver({required this.userId, required this.chatRepository});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (userId.isEmpty) {
      debugPrint('Warning: AppLifeCycleObserver initialized with empty userId');
      return;
    }

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        chatRepository.updateOnlineStatus(userId, false);
        break;
      case AppLifecycleState.resumed:
        chatRepository.updateOnlineStatus(userId, true);
        break;
      default:
        break;
    }
  }
}
