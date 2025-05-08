import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../common/custom_avatar_builder.dart';

/// on user login
Future<void> onUserLogin(String userId, String userName) async {
  try {
    print("Initializing ZegoCloud for user: $userId, $userName");
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 577934921,
      appSign:
          "e45aea09564d8d9fec6b15ccbb9b29d9300980a1ad9b52f1c1f05e5739d1546d",
      userID: userId,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      requireConfig: (ZegoCallInvitationData data) {
        final config =
            (data.invitees.length > 1)
                ? ZegoCallInvitationType.videoCall == data.type
                    ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                    : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
                : ZegoCallInvitationType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        config.avatarBuilder = customAvatarBuilder;

        config.topMenuBar.isVisible = true;
        config.topMenuBar.buttons.insert(
          0,
          ZegoCallMenuBarButtonName.minimizingButton,
        );
        config.topMenuBar.buttons.insert(
          1,
          ZegoCallMenuBarButtonName.soundEffectButton,
        );

        return config;
      },
    );
    print("ZegoCloud initialization completed successfully");
  } catch (e) {
    print("Error initializing ZegoCloud: $e");
    // Re-throw the error to be handled by the caller
    rethrow;
  }
}


void onUserLogout() {
  ZegoUIKitPrebuiltCallInvitationService().uninit();
}
