// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class CallKitService {
  static Future<void> showIncomingCall({
    required String callId,
    required String callerName,
    String? callerAvatar,
    String? handle,
    String? type,
  }) async {
    try {
      final params = CallKitParams(
        id: callId,
        nameCaller: callerName,
        appName: 'SignWave',
        avatar: callerAvatar,
        handle: handle ?? 'Video Call',
        duration: 30000,
        textAccept: 'Accept',
        textDecline: 'Decline',
        missedCallNotification: const NotificationParams(
          showNotification: true,
          isShowCallback: true,
          subtitle: 'Missed call',
          callbackText: 'Call back',
        ),
        extra: <String, dynamic>{'userId': callId},
        headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
        android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          backgroundUrl: 'assets/images/background.png',
          actionColor: '#4CAF50',
        ),
        ios: const IOSParams(
          iconName: 'CallKitLogo',
          handleType: 'generic',
          supportsVideo: true,
          maximumCallGroups: 2,
          maximumCallsPerCallGroup: 1,
          audioSessionMode: 'default',
          audioSessionActive: true,
          audioSessionPreferredSampleRate: 44100.0,
          audioSessionPreferredIOBufferDuration: 0.005,
          supportsDTMF: true,
          supportsHolding: true,
          supportsGrouping: false,
          supportsUngrouping: false,
          ringtonePath: 'system_ringtone_default',
        ),
      );

      await FlutterCallkitIncoming.showCallkitIncoming(params);
    } catch (e) {
      debugPrint('Error showing incoming call: $e');
    }
  }

  // Show outgoing call UI
  static Future<void> startOutgoingCall({
    required String callId,
    required String calleeName,
    String? calleeAvatar,
  }) async {
    try {
      final params = CallKitParams(
        id: callId,
        nameCaller: calleeName,
        handle: 'Video Call',
        type: 1,
        avatar: calleeAvatar,
        extra: <String, dynamic>{'userId': callId},
      );
      await FlutterCallkitIncoming.startCall(params);
    } catch (e) {
      debugPrint('Error starting outgoing call: $e');
    }
  }

  // End an ongoing call
  static Future<void> endCall(String callId) async {
    try {
      await FlutterCallkitIncoming.endCall(callId);
    } catch (e) {
      debugPrint('Error ending call: $e');
    }
  }

  // End all ongoing calls
  static Future<void> endAllCalls() async {
    try {
      await FlutterCallkitIncoming.endAllCalls();
    } catch (e) {
      debugPrint('Error ending all calls: $e');
    }
  }

  // Listen for call events
  static Future<void> listenerForEvents({
    required Function(CallEvent) onEvent,
  }) async {
    try {
      FlutterCallkitIncoming.onEvent.listen((event) {
        if (event != null) {
          // Convert package CallEvent to our custom CallEvent
          final customEvent = CallEvent(
            event.event.name,
            event.body,
            null, // headers not available in package CallEvent
          );
          onEvent(customEvent);
        }
      });
    } catch (e) {
      debugPrint('Error setting up call event listener: $e');
    }
  }

  // Get active calls
  static Future<List<dynamic>> getActiveCalls() async {
    try {
      return await FlutterCallkitIncoming.activeCalls();
    } catch (e) {
      debugPrint('Error getting active calls: $e');
      return [];
    }
  }

  // Initialize CallKit (especially important for iOS)
}

// Class to handle call events
class CallEvent {
  final String name;
  final dynamic body;
  final dynamic headers;

  CallEvent(this.name, this.body, this.headers);

  bool get isCallAccepted => name == CallEvent.EVENT_ACTION_CALL_ACCEPT;
  bool get isCallDeclined => name == CallEvent.EVENT_ACTION_CALL_DECLINE;
  bool get isCallEnded => name == CallEvent.EVENT_ACTION_CALL_ENDED;
  bool get isCallTimeout => name == CallEvent.EVENT_ACTION_CALL_TIMEOUT;
  bool get isCallCallback => name == CallEvent.EVENT_ACTION_CALL_CALLBACK;
  bool get isCallToggleHold => name == CallEvent.EVENT_ACTION_CALL_TOGGLE_HOLD;
  bool get isCallToggleMute => name == CallEvent.EVENT_ACTION_CALL_TOGGLE_MUTE;
  bool get isCallToggleDmtf => name == CallEvent.EVENT_ACTION_CALL_TOGGLE_DMTF;
  bool get isCallToggleGroup =>
      name == CallEvent.EVENT_ACTION_CALL_TOGGLE_GROUP;
  bool get isCallToggleAudioSession =>
      name == CallEvent.EVENT_ACTION_CALL_TOGGLE_AUDIO_SESSION;

  // Event name constants
  static const String EVENT_ACTION_CALL_INCOMING =
      'com.hiennv.flutter_callkit_incoming.ACTION_CALL_INCOMING';
  static const String EVENT_ACTION_CALL_START =
      'com.hiennv.flutter_callkit_incoming.ACTION_CALL_START';
  static const String EVENT_ACTION_CALL_ACCEPT =
      'com.hiennv.flutter_callkit_incoming.ACTION_CALL_ACCEPT';
  static const String EVENT_ACTION_CALL_DECLINE =
      'com.hiennv.flutter_callkit_incoming.ACTION_CALL_DECLINE';
  static const String EVENT_ACTION_CALL_ENDED =
      'com.hiennv.flutter_callkit_incoming.ACTION_CALL_ENDED';
  static const String EVENT_ACTION_CALL_TIMEOUT =
      'com.hiennv.flutter_callkit_incoming.ACTION_CALL_TIMEOUT';
  static const String EVENT_ACTION_CALL_CALLBACK =
      'com.hiennv.flutter_callkit_incoming.ACTION_CALL_CALLBACK';
  static const String EVENT_ACTION_CALL_TOGGLE_HOLD =
      'com.hiennv.flutter_callkit_incoming.ACTION_CALL_TOGGLE_HOLD';
  static const String EVENT_ACTION_CALL_TOGGLE_MUTE =
      'com.hiennv.flutter_callkit_incoming.ACTION_CALL_TOGGLE_MUTE';
  static const String EVENT_ACTION_CALL_TOGGLE_DMTF =
      'com.hiennv.flutter_callkit_incoming.ACTION_CALL_TOGGLE_DMTF';
  static const String EVENT_ACTION_CALL_TOGGLE_GROUP =
      'com.hiennv.flutter_callkit_incoming.ACTION_CALL_TOGGLE_GROUP';
  static const String EVENT_ACTION_CALL_TOGGLE_AUDIO_SESSION =
      'com.hiennv.flutter_callkit_incoming.ACTION_CALL_TOGGLE_AUDIO_SESSION';
}
