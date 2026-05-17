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
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
            top: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.pink,
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 22,
            child: Icon(
              Icons.event_available_rounded,
              size: 56,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 16, 18),
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
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    EditChip(
                      onTap: onEdit,
                      background: Colors.white.withValues(alpha: 0.25),
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

class _DaysNumber extends StatefulWidget {
  final int? target;
  const _DaysNumber({required this.target});

  @override
  State<_DaysNumber> createState() => _DaysNumberState();
}

class _DaysNumberState extends State<_DaysNumber> {
  double _from = 0;

  @override
  void didUpdateWidget(covariant _DaysNumber old) {
    super.didUpdateWidget(old);
    if (widget.target != old.target) {
      _from = (old.target ?? 0).toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.target ?? 0;
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: _from, end: value.toDouble()),
      builder: (_, animated, _) {
        final number = widget.target == null ? '—' : animated.round().toString();
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 58,
                fontWeight: FontWeight.w900,
                height: 1,
                letterSpacing: -2,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'daysLabel'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
