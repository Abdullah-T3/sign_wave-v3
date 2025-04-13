// import 'package:flutter/material.dart';
// import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
// import 'package:flutter/foundation.dart';

// class JitsiMeetService {
//   final JitsiMeet jitsiMeet;

//   JitsiMeetService(this.jitsiMeet);

//   // Configuration options for Jitsi Meet
//   Future<void> joinMeeting({
//     required String roomName,
//     required String displayName,
//     String? email,
//     String? avatarURL,
//     bool audioMuted = false,
//     bool videoMuted = false,
//     String? token,
//   }) async {
//     try {
//       var options = JitsiMeetConferenceOptions(
//         serverURL: "https://meet.ffmuc.net/",
//         room: roomName,
//         configOverrides: {
//           "startWithAudioMuted": audioMuted,
//           "startWithVideoMuted": videoMuted,
//           "prejoinPageEnabled": false,
//         },
//         featureFlags: {
//           "ios.recording.enabled": false,
//           "live-streaming.enabled": false,
//           "meeting-password.enabled": false,
//           "pip.enabled": true,
//           "chat.enabled": true,
//           "invite.enabled": false,
//         },
//         userInfo: JitsiMeetUserInfo(
//           displayName: displayName,
//           email: email,
//           avatar: avatarURL,
//         ),
//         token: token,
//       );

//       await jitsiMeet.join(options);
//     } catch (error) {
//       debugPrint("Error joining Jitsi meeting: $error");
//       rethrow;
//     }
//   }

//   // Close the current meeting
//   Future<void> closeMeeting() async {
//     try {
//       await jitsiMeet.hangUp();
//     } catch (error) {
//       debugPrint("Error closing Jitsi meeting: $error");
//       rethrow;
//     }
//   }
// }
