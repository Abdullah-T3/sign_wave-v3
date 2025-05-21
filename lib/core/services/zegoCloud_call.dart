import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../common/custom_avatar_builder.dart';
import '../helper/dotenv/dot_env_helper.dart';

Future<void> onUserLogin(String userId, String userName) async {
  try {
    print("Initializing ZegoCloud for user: $userId, $userName");
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: EnvHelper.getInt("ZEGO_APP_ID"),
      appSign: EnvHelper.getString("ZEGO_APP_SIGN"),
      userID: userId,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      config: ZegoCallInvitationConfig(endCallWhenInitiatorLeave: true),
      uiConfig: ZegoCallInvitationUIConfig(
        // Customize UI settings if needed
        prebuiltWithSafeArea: true,
        invitee: ZegoCallInvitationInviteeUIConfig(showCentralName: true),
      ),
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onInvitationUserStateChanged: (List) {
          // Handle user state changes (e.g., online/offline)
        },

        onIncomingCallDeclineButtonPressed: () {
          // Use reject() to properly end the call for both parties
          ZegoUIKitPrebuiltCallInvitationService().reject();
        },
        onIncomingCallAcceptButtonPressed: () {
          // Accept the call and ensure camera is properly initialized
          ZegoUIKitPrebuiltCallInvitationService().accept();
        },
      ),
      requireConfig: (ZegoCallInvitationData data) {
        final config =
            (data.invitees.length > 1)
                ? ZegoCallInvitationType.videoCall == data.type
                    ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                    : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
                : ZegoCallInvitationType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
        return config;
      },
    );
    print("ZegoCloud initialization completed successfully");
  } catch (e) {
    print("Error initializing ZegoCloud: $e");
    rethrow;
  }
}

void onUserLogout() {
  ZegoUIKitPrebuiltCallInvitationService().uninit();
}
