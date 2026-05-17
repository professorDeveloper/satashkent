import 'dart:ui';

import 'package:flutter/material.dart';

class BlurAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool scrolled;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const BlurAppBar({
    super.key,
    required this.title,
    required this.scrolled,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      flexibleSpace: scrolled
          ? RepaintBoundary(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: scaffoldBg.withValues(alpha: 0.78),
                  ),
                ),
              ),
            )
          : null,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
      ),
    );
  }
}
