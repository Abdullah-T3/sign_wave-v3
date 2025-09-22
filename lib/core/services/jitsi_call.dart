// import 'dart:developer';

// import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

// class JitsiMeetService {
//   final JitsiMeet jitsiMeet = JitsiMeet();
//   late JitsiMeetEventListener listener;
//   late JitsiMeetConferenceOptions options;
//   late String roomId;

//   JitsiMeetService({
//     required String roomId,
//     required String displayName,
//     required String avatar,
//     required String email,
//   }) {
//     listener = JitsiMeetEventListener(
//       participantJoined: (a, b, c, d) {
//         log("$a");
//         log("$b");
//         log("$c");
//         log("$d");
//       },
//       readyToClose: () => closeMeetion(),
//     );
//     options = JitsiMeetConferenceOptions(
//       serverURL: "https://meet.fmuc.net/", // problem 1
//       room: roomId,
//       configOverrides: {
//         "startWithAudioMuted": false,
//         "startWithVideoMuted": true,
//         "disableDeepLinking": true, // Disables third-party login links
//         "disableThirdPartyRequests": true, // Disables Google login entry
//         "audioQuality": {"opusMaxAverageBitrate": 32000},
//         "subject": "Sign Wave",
//       },
//       featureFlags: {
//         "video-share.enabled": false,
//         "security-options.enabled": false,
//         "meeting-password.enabled": false,
//         "prejoinpage.enabled": false,
//         "replace.participant": false,
//         "lobby-mode.enabled": false,
//         "unsafeRoomWarning.enabled": false,
//         "raise-hand.enabled": false,
//         "invite.enabled": false,
//         "car-mode.enabled": false,
//         // "audio-only.enabled": true,
//         "add-people.enabled": false,
//         "speakerstats.enabled": false,
//         // FeatureFlags.videoShareEnabled: false,
//         // FeatureFlags.securityOptionEnabled: false,
//         // FeatureFlags.meetingPasswordEnabled: false,
//       },
//       userInfo: JitsiMeetUserInfo(
//         displayName: displayName,
//         email: email,
//         avatar: avatar,
//       ),
//     );
//   }

//   Future<void> startMeeting() async {
//     try {
//       await jitsiMeet.join(options, listener);
//       log('meeting started success');
//     } catch (e) {
//       log('meeting start error $e');
//     }
//   }

//   Future<void> closeMeetion() async {
//     try {
//       await jitsiMeet.closeChat();
//     } catch (e) {
//       log("Error ending meet $e");
//     }
//   }
// }
