import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

Future<bool> showLogoutConfirm(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      final scheme = Theme.of(ctx).colorScheme;
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: scheme.surface,
        title: Text(
          'logoutTitle'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'logoutConfirmMessage'.tr(),
          style: TextStyle(
            fontSize: 14,
            color: scheme.onSurface.withValues(alpha: 0.75),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: scheme.onSurface.withValues(alpha: 0.7),
            ),
            child: Text('cancel'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brand,
              foregroundColor: Colors.white,
            ),
            child: Text('logOut'.tr()),
          ),
        ],
      );
    },
  );
  return ok ?? false;
}
