import 'package:flutter/material.dart';

class SlideTransitionWidget extends StatefulWidget {
  const SlideTransitionWidget({super.key, required this.child});
  final Widget child;

  @override
  State<SlideTransitionWidget> createState() => _SlideTransitionWidgetState();
}

// how to use this widget
// SlideTransitionWidget(child: yourWidget)
class _SlideTransitionWidgetState extends State<SlideTransitionWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _animationController,
        child: widget.child,
      ),
    );
  }
}
