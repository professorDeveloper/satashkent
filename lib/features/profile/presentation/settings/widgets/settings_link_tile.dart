import 'package:flutter/material.dart';

class SettingsLinkTile extends StatelessWidget {
  final IconData? leading;
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;

  const SettingsLinkTile({
    super.key,
    this.leading,
    required this.title,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        child: Row(
          children: [
            if (leading != null) ...[
              Icon(leading, size: 20, color: scheme.onSurface),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: TextStyle(fontSize: 14, color: muted),
              ),
              const SizedBox(width: 4),
            ],
            Icon(Icons.chevron_right_rounded, color: muted, size: 22),
          ],
        ),
      ),
    );
  }
}
