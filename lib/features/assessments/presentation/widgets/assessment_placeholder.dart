import 'package:flutter/material.dart';

class AssessmentPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;

  const AssessmentPlaceholder({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final muted =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: muted),
          const SizedBox(height: 12),
          Text(
            title,
            style:
                Theme.of(context).textTheme.titleLarge?.copyWith(color: muted),
          ),
        ],
      ),
    );
  }
}
