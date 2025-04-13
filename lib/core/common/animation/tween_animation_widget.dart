import 'package:flutter/material.dart';
import '../../Responsive/Models/device_info.dart';

class TweenAnimationWidget extends StatelessWidget {
  final Widget child;
  final DeviceInfo deviceInfo;
  final int index;
  const TweenAnimationWidget({
    super.key,
    required this.child,
    required this.deviceInfo,
    required this.index,
  });
  // how to use this widget
  // TweenAnimationWidget(index: index, deviceInfo: deviceInfo, child: PostCardWidget(post: posts[index], deviceInfo: deviceInfo, idNotMatch: isNotMatch));
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: deviceInfo.screenWidth * 0.05,
          vertical: deviceInfo.localHeight * 0.01,
        ),
        child: child,
      ),
    );
  }
}
