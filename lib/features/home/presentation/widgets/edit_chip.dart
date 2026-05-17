import 'package:flutter/material.dart';

class EditChip extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? background;
  final Color? icon;
  const EditChip({super.key, this.onTap, this.background, this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = background ?? scheme.onSurface.withValues(alpha: 0.08);
    final ic = icon ?? scheme.onSurface.withValues(alpha: 0.7);
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(Icons.edit_rounded, size: 14, color: ic),
        ),
      ),
    );
  }
}
