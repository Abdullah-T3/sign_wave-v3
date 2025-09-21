// import 'package:sign_wave_v3/core/services/fcm_service.dart';
// import 'package:sign_wave_v3/core/services/notifcation_service.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// import '../../features/home/data/repo/chat_repository.dart';
// import '../common/custom_avatar_builder.dart';
// import '../helper/dotenv/dot_env_helper.dart';

// void onUserLogout() {
//   ZegoUIKitPrebuiltCallInvitationService().uninit();
// }

// late ZegoCallUser _lastCaller;
// // ignore: unused_element
// String? _lastCallId;
// Future<void> onUserLogin(String userId, String userName) async {
//   /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
//   await ZegoUIKitPrebuiltCallInvitationService().init(
//     appID: EnvHelper.getInt("ZEGO_APP_ID"),
//     appSign: EnvHelper.getString("ZEGO_APP_SIGN"),
//     userID: userId,
//     userName: userName,
//     plugins: [ZegoUIKitSignalingPlugin()],
//     config: ZegoCallInvitationConfig(
//       permissions: [
//         ZegoCallInvitationPermission.camera,
//         ZegoCallInvitationPermission.microphone,
//       ],
//     ),
//     invitationEvents: invitationEvents,

//     notificationConfig: notificationConfig,
//     requireConfig: (ZegoCallInvitationData data) {
//       final config =
//           (data.invitees.length > 1)
//               ? ZegoCallInvitationType.videoCall == data.type
//                   ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
//                   : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
//               : ZegoCallInvitationType.videoCall == data.type
//               ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//               : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
//       config.avatarBuilder = customAvatarBuilder;
//       config.topMenuBar.isVisible = true;
//       config.turnOnCameraWhenJoining = true;
//       config.topMenuBar.isVisible = true;
//       config.duration.isVisible = true;
//       config.topMenuBar.buttons.insert(
//         0,
//         ZegoCallMenuBarButtonName.minimizingButton,
//       );
//       config.topMenuBar.buttons.insert(
//         1,
//         ZegoCallMenuBarButtonName.beautyEffectButton,
//       );
//       config.topMenuBar.buttons.insert(
//         2,
//         ZegoCallMenuBarButtonName.soundEffectButton,
//       );
//       return config;
//     },
//   );
// }

// ZegoCallInvitationNotificationConfig notificationConfig =
//     ZegoCallInvitationNotificationConfig(
//       androidNotificationConfig: ZegoCallAndroidNotificationConfig(
//         showFullScreen: true,
//         certificateIndex: ZegoSignalingPluginMultiCertificate.firstCertificate,
//         fullScreenBackgroundAssetURL: 'assets/images/call.png',
//         callChannel: ZegoCallAndroidNotificationChannelConfig(
//           channelID: "ZegoUIKit",
//           channelName: "Call Notifications",
//           sound: "call",
//           icon: "call",
//         ),
//         missedCallChannel: ZegoCallAndroidNotificationChannelConfig(
//           channelID: "MissedCall",
//           channelName: "Missed Call",
//           sound: "missed_call",
//           icon: "missed_call",
//           vibrate: false,
//         ),
//       ),
//       iOSNotificationConfig: ZegoCallIOSNotificationConfig(
//         systemCallingIconName: 'CallKitIcon',
//       ),
//     );

// ZegoUIKitPrebuiltCallInvitationEvents invitationEvents =
//     ZegoUIKitPrebuiltCallInvitationEvents(
//       onIncomingCallDeclineButtonPressed: () {
//         ChatRepository().getFcmToken(_lastCaller.id).then((callerFcmToken) {
//           sendNotification(
//             token: callerFcmToken,
//             title: "Call Declined",
//             body: "${_lastCaller.name} declined the video call",
//             data: {},
//           );
//         });
//       },
//       onIncomingCallTimeout: (String callID, ZegoCallUser caller) {
//         NotificationService().showNotification(
//           title: "Missed Call",
//           body: "You missed a video call from ${caller.name}",
//         );
//       },
//       onIncomingCallCanceled: (
//         String callID,
//         ZegoCallUser caller,
//         String extendedData,
//       ) {
//         NotificationService().showNotification(
//           title: "Missed Call",
//           body: "You missed a video call from ${caller.name}",
//           payload: "MissedCall",
//         );
//       },
//       onIncomingCallReceived: (
//         String callID,
//         ZegoCallUser caller,
//         ZegoCallInvitationType type,
//         List<ZegoCallUser> invitees,
//         String extendedData,
//       ) {
//         _lastCaller = caller;
//         _lastCallId = callID;
//       },
//       onIncomingCallAcceptButtonPressed: () {
//         ZegoUIKit().turnCameraOn(true);
//       },
//     );
