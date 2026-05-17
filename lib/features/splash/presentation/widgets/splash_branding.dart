import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'splash_logo.dart';

class SplashBranding extends StatelessWidget {
  const SplashBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(child: SplashLogo(size: 168)),
        Align(
          alignment: const Alignment(0, 0.92),
          child: Text(
            'SATASHKENT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 4,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.55),
            ),
          )
              .animate(delay: 2200.ms)
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.4, end: 0, curve: Curves.easeOutCubic),
        ),
      ],
    );
  }
}
