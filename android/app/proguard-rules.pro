# Video Call Invitation
-keep class im.zego.uikit.prebuilt.call.ZegoSendCallInvitationButton { *; }
-keep class im.zego.uikit.prebuilt.call.ZegoUIKitPrebuiltCallService { *; }
# Events and Listeners
-keep class im.zego.uikit.service.defines.** { *; }
-keep interface im.zego.uikitprebuilt.**.ZegoInvitationCallback { *; }

#-keep class im.zego.uikit.service.defines.** { *; }
#-keep interface im.zego.uikitprebuilt.**.ZegoInvitationCallback { *; }
## Suppress unsupported warnings
-dontwarn com.itgsa.opensdk.mediaunit.KaraokeMediaHelper
-dontwarn java.beans.ConstructorProperties
-dontwarn java.beans.Transient
-dontwarn org.w3c.dom.bootstrap.DOMImplementationRegistry
#
