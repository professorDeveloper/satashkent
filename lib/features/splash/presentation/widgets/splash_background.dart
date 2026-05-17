import 'package:flutter/material.dart';

class SplashBackground extends StatelessWidget {
  final Widget child;
  const SplashBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }
}
