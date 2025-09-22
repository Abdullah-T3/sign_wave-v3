// import 'package:flutter/material.dart';
// import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
// import 'package:sign_wave_v3/core/services/call_manager.dart';

// class JitsiCallButton extends StatelessWidget {
//   final String userID;
//   final String userName;
//   final String userAvatar;
//   final String callerID;
//   final String callerName;
//   final String callerAvatar;
//   final String calleeFcmToken;
//   final Function(String code, String message, List<String>)? onCallFinished;

//   const JitsiCallButton({
//     super.key,
//     required this.userID,
//     required this.userName,
//     required this.userAvatar,
//     required this.callerID,
//     required this.callerName,
//     required this.callerAvatar,
//     required this.calleeFcmToken,
//     this.onCallFinished,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InfoWidget(
//       builder: (context, deviceInfo) {
//         return GestureDetector(
//           onTap: () => _startVideoCall(context),
//           child: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.primary,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withAlpha(30),
//                   offset: const Offset(1, 1),
//                   blurRadius: 3,
//                 ),
//               ],
//             ),
//             child: const Icon(Icons.video_call, color: Colors.white, size: 24),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _startVideoCall(BuildContext context) async {
//     try {
//       // Show loading indicator
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const Center(child: CircularProgressIndicator()),
//       );

//       // Start outgoing call using CallManager
//       await CallManager().startOutgoingCall(
//         callerId: callerID,
//         callerName: callerName,
//         callerAvatar: callerAvatar,
//         calleeId: userID,
//         calleeName: userName,
//         calleeAvatar: userAvatar,
//         calleeFcmToken: calleeFcmToken,
//       );

//       // Close loading dialog
//       if (context.mounted) {
//         Navigator.of(context).pop();
//       }

//       // Call the callback if provided
//       onCallFinished?.call("success", "Call started successfully", []);
//     } catch (error) {
//       // Close loading dialog
//       if (context.mounted) {
//         Navigator.of(context).pop();
//       }

//       // Show error message
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to start video call: $error'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }

//       // Call the callback with error
//       onCallFinished?.call("error", error.toString(), []);
//     }
//   }
// }
