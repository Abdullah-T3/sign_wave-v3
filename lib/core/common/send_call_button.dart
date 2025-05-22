import 'package:flutter/material.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class SendCallButton extends StatelessWidget {
  final String userID;
  final String userName;
  final Function(String code, String message, List<String>)? onCallFinished;
  const SendCallButton({
    super.key,
    required this.userID,
    required this.userName,
    this.onCallFinished,
  });
  @override
  Widget build(BuildContext context) {
    final invitees = [ZegoUIKitUser(id: userID, name: userName)];
    return InfoWidget(
      builder: (context, deviceInfo) {
        return ZegoSendCallInvitationButton(
          isVideoCall: true,
          invitees: invitees,
          resourceID: 'zego_data',
          iconSize: Size(50, 50),
          buttonSize: Size(50, 50),
          timeoutSeconds: 30,

          icon: ButtonIcon(
            icon: const Icon(Icons.video_call, color: Colors.white),
          ),
          onPressed: onCallFinished,
        );
      },
    );
  }
}
