import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';

class YourCodeCard extends StatelessWidget {
  static const String linkBase = 'https://1600.satashkent.uz/auth/?referralCode=';
  final String? code;
  const YourCodeCard({super.key, required this.code});

  String? get link => code == null ? null : '$linkBase$code';

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final muted =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'yourReferralCode'.tr(),
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'shareCodeHint'.tr(),
            style: TextStyle(fontSize: 12.5, color: muted),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 36,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: code == null
                    ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.brand,
                        ),
                      )
                    : SelectableText(
                        code!,
                        key: const ValueKey('code'),
                        style: const TextStyle(
                          color: AppColors.brand,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: link == null
                      ? null
                      : () => copyLink(context, link!),
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: Text('copyLink'.tr()),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    side:
                        BorderSide(color: Theme.of(context).dividerColor),
                    foregroundColor:
                        Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: link == null ? null : () => shareLink(link!),
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: Text('share'.tr()),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(44),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void copyLink(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('linkCopied'.tr()),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> shareLink(String value) async {
    await SharePlus.instance.share(ShareParams(text: value));
  }
}
