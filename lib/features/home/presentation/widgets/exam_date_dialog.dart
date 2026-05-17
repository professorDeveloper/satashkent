import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';

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

class _ExamDateDialog extends StatefulWidget {
  final DateTime? initial;
  const _ExamDateDialog({required this.initial});

  @override
  State<_ExamDateDialog> createState() => _ExamDateDialogState();
}

class _ExamDateDialogState extends State<_ExamDateDialog> {
  late DateTime? selected = _matchKnown(widget.initial);

  static final List<DateTime> _satDates = _buildUpcomingSatDates();

  static DateTime? _matchKnown(DateTime? d) {
    if (d == null) return null;
    for (final s in _satDates) {
      if (s.year == d.year && s.month == d.month && s.day == d.day) return s;
    }
    return null;
  }

  static List<DateTime> _buildUpcomingSatDates() {
    final now = DateTime.now();
    final base = <DateTime>[
      DateTime(now.year, 3, 14),
      DateTime(now.year, 5, 2),
      DateTime(now.year, 6, 6),
      DateTime(now.year, 8, 15),
      DateTime(now.year, 9, 12),
      DateTime(now.year, 10, 3),
      DateTime(now.year, 11, 7),
      DateTime(now.year, 12, 5),
      DateTime(now.year + 1, 3, 13),
      DateTime(now.year + 1, 5, 1),
      DateTime(now.year + 1, 6, 5),
    ];
    return base.where((d) => d.isAfter(now)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'examDayTitle'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Center(
              child: Image.asset(
                AppAssets.examDate,
                height: 130,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'examDateLabel'.tr(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<DateTime>(
              initialValue: selected,
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              hint: Text('selectExamDate'.tr()),
              items: [
                for (final d in _ExamDateDialogState._satDates)
                  DropdownMenuItem(
                    value: d,
                    child: Text(_formatDate(d)),
                  ),
              ],
              onChanged: (v) => setState(() => selected = v),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: selected == null
                  ? null
                  : () => Navigator.of(context).pop(selected),
              style: FilledButton.styleFrom(
                backgroundColor: scheme.onSurface,
                foregroundColor: scheme.surface,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'submit'.tr(),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}
