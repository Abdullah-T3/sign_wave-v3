// import 'package:flutter/material.dart';
// import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
// import 'package:flutter/foundation.dart';
//
// class JitsiMeetService {
//   final JitsiMeet jitsiMeet;
//   JitsiMeetEventListener? _listener;
//
//   // Callback functions for events
//   Function(dynamic)? onConferenceJoined;
//   Function(dynamic)? onConferenceTerminated;
//   Function(dynamic)? onConferenceWillJoin;
//   Function(dynamic)? onParticipantJoined;
//   Function(dynamic)? onParticipantLeft;
//   Function(dynamic)? onAudioMutedChanged;
//   Function(dynamic)? onVideoMutedChanged;
//   Function(dynamic)? onScreenShareToggled;
//   Function(dynamic)? onChatMessageReceived;
//   Function(dynamic)? onParticipantsInfoRetrieved;
//
//   JitsiMeetService(this.jitsiMeet) {
//     _initListener();
//   }
//
//   void _initListener() {
//     _listener = JitsiMeetEventListener(
//       conferenceJoined: (url) {
//         debugPrint("Conference joined: $url");
//         if (onConferenceJoined != null) onConferenceJoined!(url);
//       },
//       conferenceTerminated: (url, error) {
//         debugPrint("Conference terminated: $url, $error");
//         if (onConferenceTerminated != null)
//           onConferenceTerminated!({"url": url, "error": error});
//       },
//       conferenceWillJoin: (url) {
//         debugPrint("Conference will join: $url");
//         if (onConferenceWillJoin != null) onConferenceWillJoin!(url);
//       },
//       participantJoined: (email, name, role, participantId) {
//         debugPrint(
//           "Participant joined: email: $email, name: $name, role: $role, participantId: $participantId",
//         );
//         if (onParticipantJoined != null)
//           onParticipantJoined!({
//             "email": email,
//             "name": name,
//             "role": role,
//             "participantId": participantId,
//           });
//       },
//       participantLeft: (participantId) {
//         debugPrint("Participant left: $participantId");
//         if (onParticipantLeft != null) onParticipantLeft!(participantId);
//       },
//       audioMutedChanged: (muted) {
//         debugPrint("Audio muted changed: $muted");
//         if (onAudioMutedChanged != null) onAudioMutedChanged!(muted);
//       },
//       videoMutedChanged: (muted) {
//         debugPrint("Video muted changed: $muted");
//         if (onVideoMutedChanged != null) onVideoMutedChanged!(muted);
//       },
//       screenShareToggled: (participantId, sharing) {
//         debugPrint(
//           "Screen share toggled: participantId: $participantId, sharing: $sharing",
//         );
//         if (onScreenShareToggled != null)
//           onScreenShareToggled!({
//             "participantId": participantId,
//             "sharing": sharing,
//           });
//       },
//
//       participantsInfoRetrieved: (participantsInfo) {
//         debugPrint("Participants info retrieved: $participantsInfo");
//         if (onParticipantsInfoRetrieved != null)
//           onParticipantsInfoRetrieved!(participantsInfo);
//       },
//     );
//   }
//
//   // Configuration options for Jitsi Meet
//   Future<void> joinMeeting({
//     required String roomName,
//     required String displayName,
//     String? email,
//     String? avatarURL,
//     bool audioMuted = false,
//     bool videoMuted = false,
//     String? token,
//     String? serverURL,
//     Map<String, dynamic>? configOverrides,
//     Map<String, dynamic>? featureFlags,
//   }) async {
//     try {
//       var options = JitsiMeetConferenceOptions(
//         serverURL: serverURL ?? "https://meet.ffmuc.net/",
//         room: roomName,
//         configOverrides:
//             configOverrides ??
//             {
//               "startWithAudioMuted": audioMuted,
//               "startWithVideoMuted": videoMuted,
//               "prejoinPageEnabled": false,
//             },
//         featureFlags:
//             featureFlags ??
//             {
//               "ios.recording.enabled": false,
//               "live-streaming.enabled": false,
//               "meeting-password.enabled": false,
//               "pip.enabled": true,
//               "chat.enabled": true,
//               "invite.enabled": false,
//             },
//         userInfo: JitsiMeetUserInfo(
//           displayName: displayName,
//           email: email,
//           avatar: avatarURL,
//         ),
//         token: token,
//       );
//
//       await jitsiMeet.join(options, _listener);
//     } catch (error) {
//       debugPrint("Error joining Jitsi meeting: $error");
//       rethrow;
//     }
//   }
//
//   // Close the current meeting
//   Future<void> closeMeeting() async {
//     try {
//       await jitsiMeet.hangUp();
//     } catch (error) {
//       debugPrint("Error closing Jitsi meeting: $error");
//       rethrow;
//     }
//   }
//
//   // Mute/unmute audio
//   Future<void> setAudioMuted(bool muted) async {
//     try {
//       await jitsiMeet.setAudioMuted(muted);
//     } catch (error) {
//       debugPrint("Error setting audio muted: $error");
//       rethrow;
//     }
//   }
//
//   // Mute/unmute video
//   Future<void> setVideoMuted(bool muted) async {
//     try {
//       await jitsiMeet.setVideoMuted(muted);
//     } catch (error) {
//       debugPrint("Error setting video muted: $error");
//       rethrow;
//     }
//   }
//
//   // Toggle screen sharing
//   Future<void> toggleScreenShare(bool enabled) async {
//     try {
//       await jitsiMeet.toggleScreenShare(enabled);
//     } catch (error) {
//       debugPrint("Error toggling screen share: $error");
//       rethrow;
//     }
//   }
//
//   // Send a chat message to all participants or a specific participant
//   Future<void> sendChatMessage({String? to, required String message}) async {
//     try {
//       await jitsiMeet.sendChatMessage(to: to, message: message);
//     } catch (error) {
//       debugPrint("Error sending chat message: $error");
//       rethrow;
//     }
//   }
//
//   // Open the chat dialog
//   Future<void> openChat([String? participantId]) async {
//     try {
//       await jitsiMeet.openChat(participantId);
//     } catch (error) {
//       debugPrint("Error opening chat: $error");
//       rethrow;
//     }
//   }
//
//   // Close the chat dialog
//   Future<void> closeChat() async {
//     try {
//       await jitsiMeet.closeChat();
//     } catch (error) {
//       debugPrint("Error closing chat: $error");
//       rethrow;
//     }
//   }
//
//   // Send a message via the data channel
//   Future<void> sendEndpointTextMessage({
//     String? to,
//     required String message,
//   }) async {
//     try {
//       await jitsiMeet.sendEndpointTextMessage(to: to, message: message);
//     } catch (error) {
//       debugPrint("Error sending endpoint text message: $error");
//       rethrow;
//     }
//   }
//
//   // Retrieve information about participants
//   Future<void> retrieveParticipantsInfo() async {
//     try {
//       await jitsiMeet.retrieveParticipantsInfo();
//     } catch (error) {
//       debugPrint("Error retrieving participants info: $error");
//       rethrow;
//     }
//   }
// }
