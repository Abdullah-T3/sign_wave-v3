// import 'dart:async';
// import 'dart:developer';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:sign_wave_v3/core/services/fcm_service.dart';
// import 'package:sign_wave_v3/core/services/jitsi_call.dart';
// import 'package:sign_wave_v3/core/services/call_dialog_ui.dart';

// enum CallState { idle, initiating, ringing, connected, ended, declined, missed }

// enum CallType { incoming, outgoing }

// class CallInfo {
//   final String callId;
//   final String callerId;
//   final String callerName;
//   final String callerAvatar;
//   final String calleeId;
//   final String calleeName;
//   final String calleeAvatar;
//   final String roomId;
//   final CallType type;
//   final DateTime timestamp;

//   CallInfo({
//     required this.callId,
//     required this.callerId,
//     required this.callerName,
//     required this.callerAvatar,
//     required this.calleeId,
//     required this.calleeName,
//     required this.calleeAvatar,
//     required this.roomId,
//     required this.type,
//     required this.timestamp,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'callId': callId,
//       'callerId': callerId,
//       'callerName': callerName,
//       'callerAvatar': callerAvatar,
//       'calleeId': calleeId,
//       'calleeName': calleeName,
//       'calleeAvatar': calleeAvatar,
//       'roomId': roomId,
//       'type': type.name,
//       'timestamp': timestamp.toIso8601String(),
//     };
//   }

//   factory CallInfo.fromMap(Map<String, dynamic> map) {
//     return CallInfo(
//       callId: map['callId'] ?? '',
//       callerId: map['callerId'] ?? '',
//       callerName: map['callerName'] ?? '',
//       callerAvatar: map['callerAvatar'] ?? '',
//       calleeId: map['calleeId'] ?? '',
//       calleeName: map['calleeName'] ?? '',
//       calleeAvatar: map['calleeAvatar'] ?? '',
//       roomId: map['roomId'] ?? '',
//       type: CallType.values.firstWhere(
//         (e) => e.name == map['type'],
//         orElse: () => CallType.outgoing,
//       ),
//       timestamp: DateTime.parse(
//         map['timestamp'] ?? DateTime.now().toIso8601String(),
//       ),
//     );
//   }
// }

// class CallManager {
//   static final CallManager _instance = CallManager._internal();
//   factory CallManager() => _instance;
//   CallManager._internal();

//   // Current call state
//   CallState _currentState = CallState.idle;
//   CallInfo? _currentCall;
//   JitsiMeetService? _jitsiService;
//   StreamSubscription<CallEvent>? _callEventSubscription;
//   Timer? _callTimeoutTimer;

//   // Getters
//   CallState get currentState => _currentState;
//   CallInfo? get currentCall => _currentCall;
//   bool get isInCall => _currentState == CallState.connected;
//   bool get hasActiveCall => _currentState != CallState.idle;

//   // Callbacks
//   Function(CallState)? onCallStateChanged;
//   Function(CallInfo)? onCallStarted;
//   Function(CallInfo)? onCallEnded;

//   /// Initialize the call manager
//   Future<void> initialize() async {
//     log('CallManager: Initializing...');

//     // Set up FCM background message handler
//     FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);

//     // Set up FCM foreground message handler
//     FcmService.onForgroundMessage();

//     // Set up call event listener
//     await _setupCallEventListener();

//     log('CallManager: Initialized successfully');
//   }

//   /// Start an outgoing call
//   Future<void> startOutgoingCall({
//     required String callerId,
//     required String callerName,
//     required String callerAvatar,
//     required String calleeId,
//     required String calleeName,
//     required String calleeAvatar,
//     required String calleeFcmToken,
//   }) async {
//     if (hasActiveCall) {
//       log('CallManager: Cannot start call - already in call');
//       return;
//     }

//     try {
//       _currentState = CallState.initiating;
//       onCallStateChanged?.call(_currentState);

//       // Generate unique call ID and room ID
//       final callId = 'call_${DateTime.now().millisecondsSinceEpoch}';
//       final roomId =
//           'room_${callerId}_${calleeId}_${DateTime.now().millisecondsSinceEpoch}';

//       // Create call info
//       _currentCall = CallInfo(
//         callId: callId,
//         callerId: callerId,
//         callerName: callerName,
//         callerAvatar: callerAvatar,
//         calleeId: calleeId,
//         calleeName: calleeName,
//         calleeAvatar: calleeAvatar,
//         roomId: roomId,
//         type: CallType.outgoing,
//         timestamp: DateTime.now(),
//       );

//       log('CallManager: Starting outgoing call to $calleeName');

//       // Show outgoing call UI
//       await CallKitService.startOutgoingCall(
//         callId: callId,
//         calleeName: calleeName,
//         calleeAvatar: calleeAvatar,
//       );

//       // Send FCM notification to callee
//       await sendNotification(
//         token: calleeFcmToken,
//         title: 'Incoming Video Call',
//         body: '$callerName is calling you',
//         data: _currentCall!.toMap(),
//       );

//       _currentState = CallState.ringing;
//       onCallStateChanged?.call(_currentState);

//       // Set up call timeout
//       _setupCallTimeout();

//       onCallStarted?.call(_currentCall!);
//     } catch (e) {
//       log('CallManager: Error starting outgoing call: $e');
//       await _endCall(CallState.ended);
//     }
//   }

//   /// Handle incoming call from FCM notification
//   Future<void> handleIncomingCall(CallInfo callInfo) async {
//     if (hasActiveCall) {
//       log('CallManager: Cannot accept incoming call - already in call');
//       return;
//     }

//     try {
//       _currentCall = callInfo;
//       _currentState = CallState.ringing;
//       onCallStateChanged?.call(_currentState);

//       log('CallManager: Handling incoming call from ${callInfo.callerName}');

//       // Show incoming call UI
//       await CallKitService.showIncomingCall(
//         callId: callInfo.callId,
//         callerName: callInfo.callerName,
//         callerAvatar: callInfo.callerAvatar,
//         handle: 'Video Call',
//         type: 'video',
//       );

//       // Set up call timeout
//       _setupCallTimeout();
//     } catch (e) {
//       log('CallManager: Error handling incoming call: $e');
//       await _endCall(CallState.ended);
//     }
//   }

//   /// Accept an incoming call
//   Future<void> acceptCall() async {
//     if (_currentCall == null || _currentState != CallState.ringing) {
//       log('CallManager: No call to accept');
//       return;
//     }

//     try {
//       log('CallManager: Accepting call from ${_currentCall!.callerName}');

//       // Cancel timeout timer
//       _callTimeoutTimer?.cancel();

//       // Start Jitsi meeting
//       _jitsiService = JitsiMeetService(
//         roomId: _currentCall!.roomId,
//         displayName: _currentCall!.calleeName,
//         avatar: _currentCall!.calleeAvatar,
//         email: '${_currentCall!.calleeId}@signwave.app',
//       );

//       await _jitsiService!.startMeeting();

//       _currentState = CallState.connected;
//       onCallStateChanged?.call(_currentState);

//       // Send acceptance notification to caller
//       await _sendCallResponse('accepted');
//     } catch (e) {
//       log('CallManager: Error accepting call: $e');
//       await _endCall(CallState.ended);
//     }
//   }

//   /// Decline an incoming call
//   Future<void> declineCall() async {
//     if (_currentCall == null || _currentState != CallState.ringing) {
//       log('CallManager: No call to decline');
//       return;
//     }

//     try {
//       log('CallManager: Declining call from ${_currentCall!.callerName}');

//       // Cancel timeout timer
//       _callTimeoutTimer?.cancel();

//       // End call UI
//       await CallKitService.endCall(_currentCall!.callId);

//       // Send decline notification to caller
//       await _sendCallResponse('declined');

//       await _endCall(CallState.declined);
//     } catch (e) {
//       log('CallManager: Error declining call: $e');
//       await _endCall(CallState.ended);
//     }
//   }

//   /// End current call
//   Future<void> endCall() async {
//     if (_currentCall == null) {
//       log('CallManager: No call to end');
//       return;
//     }

//     try {
//       log('CallManager: Ending call');

//       // Cancel timeout timer
//       _callTimeoutTimer?.cancel();

//       // Close Jitsi meeting
//       if (_jitsiService != null) {
//         await _jitsiService!.closeMeetion();
//         _jitsiService = null;
//       }

//       // End call UI
//       await CallKitService.endCall(_currentCall!.callId);

//       // Send end notification to other party
//       await _sendCallResponse('ended');

//       await _endCall(CallState.ended);
//     } catch (e) {
//       log('CallManager: Error ending call: $e');
//       await _endCall(CallState.ended);
//     }
//   }

//   /// Handle call response from other party
//   Future<void> handleCallResponse(String response) async {
//     if (_currentCall == null) {
//       log('CallManager: No call to handle response for');
//       return;
//     }

//     try {
//       log('CallManager: Handling call response: $response');

//       // Cancel timeout timer
//       _callTimeoutTimer?.cancel();

//       switch (response) {
//         case 'accepted':
//           // Start Jitsi meeting
//           _jitsiService = JitsiMeetService(
//             roomId: _currentCall!.roomId,
//             displayName: _currentCall!.callerName,
//             avatar: _currentCall!.callerAvatar,
//             email: '${_currentCall!.callerId}@signwave.app',
//           );

//           await _jitsiService!.startMeeting();

//           _currentState = CallState.connected;
//           onCallStateChanged?.call(_currentState);
//           break;

//         case 'declined':
//           await _endCall(CallState.declined);
//           break;

//         case 'ended':
//           await _endCall(CallState.ended);
//           break;

//         default:
//           log('CallManager: Unknown call response: $response');
//       }
//     } catch (e) {
//       log('CallManager: Error handling call response: $e');
//       await _endCall(CallState.ended);
//     }
//   }

//   /// Set up call event listener
//   Future<void> _setupCallEventListener() async {
//     try {
//       await CallKitService.listenerForEvents(
//         onEvent: (CallEvent event) {
//           log('CallManager: Call event received: ${event.name}');

//           switch (event.name) {
//             case CallEvent.EVENT_ACTION_CALL_ACCEPT:
//               acceptCall();
//               break;
//             case CallEvent.EVENT_ACTION_CALL_DECLINE:
//               declineCall();
//               break;
//             case CallEvent.EVENT_ACTION_CALL_ENDED:
//               endCall();
//               break;
//             case CallEvent.EVENT_ACTION_CALL_TIMEOUT:
//               _handleCallTimeout();
//               break;
//             default:
//               log('CallManager: Unhandled call event: ${event.name}');
//           }
//         },
//       );
//     } catch (e) {
//       log('CallManager: Error setting up call event listener: $e');
//     }
//   }

//   /// Set up call timeout
//   void _setupCallTimeout() {
//     _callTimeoutTimer?.cancel();
//     _callTimeoutTimer = Timer(const Duration(seconds: 30), () {
//       _handleCallTimeout();
//     });
//   }

//   /// Handle call timeout
//   Future<void> _handleCallTimeout() async {
//     if (_currentCall == null) return;

//     log('CallManager: Call timeout for ${_currentCall!.callId}');

//     // Send timeout notification to other party
//     await _sendCallResponse('timeout');

//     await _endCall(CallState.missed);
//   }

//   /// Send call response notification
//   Future<void> _sendCallResponse(String response) async {
//     if (_currentCall == null) return;

//     try {
//       // This would typically send to your backend which then sends FCM
//       // For now, we'll just log it
//       log('CallManager: Sending call response: $response');

//       // TODO: Implement actual FCM sending to other party
//       // await sendNotification(
//       //   token: otherPartyFcmToken,
//       //   title: 'Call Response',
//       //   body: response,
//       //   data: {
//       //     'callId': _currentCall!.callId,
//       //     'response': response,
//       //   },
//       // );
//     } catch (e) {
//       log('CallManager: Error sending call response: $e');
//     }
//   }

//   /// End call and cleanup
//   Future<void> _endCall(CallState endState) async {
//     try {
//       _currentState = endState;
//       onCallStateChanged?.call(_currentState);

//       if (_currentCall != null) {
//         onCallEnded?.call(_currentCall!);
//       }

//       // Cleanup
//       _callTimeoutTimer?.cancel();
//       _jitsiService = null;
//       _currentCall = null;
//       _currentState = CallState.idle;
//       onCallStateChanged?.call(_currentState);

//       log('CallManager: Call ended with state: $endState');
//     } catch (e) {
//       log('CallManager: Error ending call: $e');
//     }
//   }

//   /// Send notification using FCM
//   Future<void> sendNotification({
//     required String token,
//     required String title,
//     required String body,
//     required Map<String, dynamic> data,
//   }) async {
//     try {
//       await sendNotification(
//         token: token,
//         title: title,
//         body: body,
//         data: data.map((key, value) => MapEntry(key, value.toString())),
//       );
//     } catch (e) {
//       log('CallManager: Error sending notification: $e');
//     }
//   }

//   /// FCM background message handler
//   static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
//     log('CallManager: Handling background message: ${message.messageId}');

//     try {
//       final data = message.data;
//       if (data['type'] == 'call_invitation') {
//         final callInfo = CallInfo.fromMap(data);
//         await CallManager().handleIncomingCall(callInfo);
//       } else if (data['type'] == 'call_response') {
//         await CallManager().handleCallResponse(data['response'] ?? '');
//       }
//     } catch (e) {
//       log('CallManager: Error handling background message: $e');
//     }
//   }

//   /// Dispose resources
//   void dispose() {
//     _callTimeoutTimer?.cancel();
//     _callEventSubscription?.cancel();
//     _jitsiService = null;
//     _currentCall = null;
//     _currentState = CallState.idle;
//   }
// }
