import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlurAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool scrolled;
  final List<Widget>? actions;
  final Widget? leading;

  const BlurAppBar({
    super.key,
    required this.title,
    required this.scrolled,
    this.actions,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final overlay = isDark
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          );
    return AppBar(
      systemOverlayStyle: overlay,
      backgroundColor:
          scrolled ? scaffoldBg.withValues(alpha: 0.94) : Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      leading: leading,
      actions: actions,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
