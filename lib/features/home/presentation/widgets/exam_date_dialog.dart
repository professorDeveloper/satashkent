import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_dialog.dart';

Future<DateTime?> showExamDateDialog(
  BuildContext context, {
  required DateTime? initial,
}) {
  return showDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _ExamDateDialog(initial: initial),
  );
}

const _monthShort = [
  'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
  'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
];

List<DateTime> _upcomingSatDates() {
  final now = DateTime.now();
  final all = <DateTime>[
    DateTime(now.year, 3, 14),
    DateTime(now.year, 5, 2),
    DateTime(now.year, 6, 6),
    DateTime(now.year, 8, 15),
    DateTime(now.year, 9, 12),
    DateTime(now.year, 10, 3),
    DateTime(now.year, 11, 7),
    DateTime(now.year, 12, 5),
  ];
  return all.where((d) => d.isAfter(now)).toList();
}

class _ExamDateDialog extends StatefulWidget {
  final DateTime? initial;
  const _ExamDateDialog({required this.initial});

  @override
  State<_ExamDateDialog> createState() => _ExamDateDialogState();
}

class _ExamDateDialogState extends State<_ExamDateDialog> {
  late final List<DateTime> dates = _upcomingSatDates();
  late DateTime? selected = _findMatch();

  DateTime? _findMatch() {
    if (widget.initial == null) return null;
    for (final d in dates) {
      if (d.year == widget.initial!.year &&
          d.month == widget.initial!.month &&
          d.day == widget.initial!.day) {
        return d;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'examDayTitle'.tr(),
      submitLabel: 'submit'.tr(),
      onSubmit: selected == null
          ? null
          : () => Navigator.of(context).pop(selected),
      child: dates.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'noUpcomingDates'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: dates.length,
              itemBuilder: (_, i) {
                final d = dates[i];
                return _DateTile(
                  date: d,
                  active: selected == d,
                  onTap: () => setState(() => selected = d),
                );
              },
            ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final DateTime date;
  final bool active;
  final VoidCallback onTap;
  const _DateTile({
    required this.date,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(14);
    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: active
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.brand, AppColors.brandDark],
                  )
                : null,
            color: active ? null : scheme.surface,
            border: active
                ? null
                : Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 0.8,
                  ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _monthShort[date.month - 1],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: active
                      ? Colors.white.withValues(alpha: 0.9)
                      : scheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  color: active ? Colors.white : scheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                date.year.toString(),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: active
                      ? Colors.white.withValues(alpha: 0.85)
                      : scheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
