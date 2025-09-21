// import 'package:flutter/material.dart';
// import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class SendCallButton extends StatelessWidget {
//   final String userID;
//   final String userName;
//   final Function(String code, String message, List<String>)? onCallFinished;
//   const SendCallButton({
//     super.key,
//     required this.userID,
//     required this.userName,
//     this.onCallFinished,
//   });
//   @override
//   Widget build(BuildContext context) {
//     final invitees = [ZegoUIKitUser(id: userID, name: userName)];
//     return InfoWidget(
//       builder: (context, deviceInfo) {
//         return ZegoSendCallInvitationButton(
//           isVideoCall: true,
//           invitees: invitees,
//           resourceID: 'zego_data',
//           iconSize: Size(40, 40),
//           buttonSize: Size(40, 40),
//           timeoutSeconds: 30,
//           notificationMessage: 'Video Call',
//           notificationTitle: 'SignWave',
//           networkLoadingConfig: ZegoNetworkLoadingConfig(
//             progressColor: Theme.of(context).colorScheme.primary,
//           ),
//           icon: ButtonIcon(
//             icon: Icon(
//               Icons.video_call,
//               color: Colors.white,
//               shadows: [
//                 Shadow(
//                   color: Colors.black,
//                   offset: Offset(1, 1),
//                   blurRadius: 3,
//                 ),
//               ],
//             ),
//           ),
//           onPressed: onCallFinished,
//         );
//       },
//     );
//   }
// }
