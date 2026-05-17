import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'edit_chip.dart';

class DaysLeftCard extends StatelessWidget {
  final DateTime? tillExam;
  final VoidCallback onEdit;
  const DaysLeftCard({super.key, required this.tillExam, required this.onEdit});

  int? get daysLeft {
    if (tillExam == null) return null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return tillExam!.difference(today).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final days = daysLeft;
    return Container(
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brand, AppColors.brandDark],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -80,
            top: -90,
            child: Container(
              width: 230,
              height: 230,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.pink,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DaysNumber(target: days),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'leftUntilExam'.tr(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    EditChip(
                      onTap: onEdit,
                      background: Colors.white.withValues(alpha: 0.22),
                      icon: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DaysNumber extends StatelessWidget {
  final int? target;
  const _DaysNumber({required this.target});

  @override
  Widget build(BuildContext context) {
    final value = target ?? 0;
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      builder: (_, animated, _) {
        final number = target == null ? '—' : animated.round().toString();
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFFFE3E9)],
              ).createShader(rect),
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: -1.2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'daysLabel'.tr(),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
