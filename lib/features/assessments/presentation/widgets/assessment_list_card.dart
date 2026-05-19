import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/assessment_item.dart';

class AssessmentListCard extends StatelessWidget {
  final AssessmentItem item;
  final VoidCallback? onStart;

  const AssessmentListCard({
    super.key,
    required this.item,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.6);
    final radius = BorderRadius.circular(18);
    final sections = item.sections;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: radius,
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _StatePill(state: item.state),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            finishesAt: item.finishesAt,
            totalQuestions: item.total,
            muted: muted,
          ),
          if (sections.isNotEmpty) ...[
            const SizedBox(height: 14),
            for (var i = 0; i < sections.length; i++) ...[
              _SectionProgress(section: sections[i]),
              if (i != sections.length - 1) const SizedBox(height: 10),
            ],
          ],
          if (item.fullScreenRequired || item.desmosEnabled) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (item.fullScreenRequired)
                  _BadgeChip(
                    icon: Icons.fullscreen_rounded,
                    label: 'fullScreen'.tr(),
                  ),
                if (item.desmosEnabled)
                  _BadgeChip(
                    icon: Icons.calculate_outlined,
                    label: 'desmosLabel'.tr(),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          _ActionButton(item: item, onStart: onStart),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final DateTime? finishesAt;
  final int totalQuestions;
  final Color muted;

  const _InfoRow({
    required this.finishesAt,
    required this.totalQuestions,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    final parts = <Widget>[];
    if (finishesAt != null) {
      parts.add(_iconText(
        Icons.event_outlined,
        DateFormat('d MMM').format(finishesAt!.toLocal()),
        muted,
      ));
    }
    if (totalQuestions > 0) {
      if (parts.isNotEmpty) parts.add(_dot(muted));
      parts.add(_iconText(
        Icons.help_outline_rounded,
        '$totalQuestions ${'questions'.tr()}',
        muted,
      ));
    }
    if (parts.isEmpty) return const SizedBox.shrink();
    return Row(children: parts);
  }

  Widget _iconText(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 15),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _dot(Color color) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.6),
          ),
        ),
      );
}

class _SectionProgress extends StatelessWidget {
  final AssessmentSection section;
  const _SectionProgress({required this.section});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.6);
    final progress = section.total == 0
        ? 0.0
        : (section.submitted / section.total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                section.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '${section.submitted} / ${section.total}',
              style: TextStyle(
                color: muted,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: scheme.onSurface.withValues(alpha: 0.08),
            valueColor: const AlwaysStoppedAnimation(AppColors.brand),
          ),
        ),
      ],
    );
  }
}

class _StatePill extends StatelessWidget {
  final String state;
  const _StatePill({required this.state});

  @override
  Widget build(BuildContext context) {
    final config = _configFor(state);
    if (config == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        config.label.tr(),
        style: TextStyle(
          color: config.fg,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  _PillConfig? _configFor(String state) {
    switch (state) {
      case 'planned':
        return _PillConfig(
          label: 'statePlanned',
          fg: const Color(0xFF1D7AFC),
          bg: const Color(0xFF1D7AFC).withValues(alpha: 0.14),
        );
      case 'active':
        return _PillConfig(
          label: 'stateActive',
          fg: const Color(0xFFE08C00),
          bg: const Color(0xFFE08C00).withValues(alpha: 0.14),
        );
      case 'passed':
        return _PillConfig(
          label: 'statePassed',
          fg: AppColors.success,
          bg: AppColors.success.withValues(alpha: 0.14),
        );
      case 'expired':
        return _PillConfig(
          label: 'stateExpired',
          fg: AppColors.error,
          bg: AppColors.error.withValues(alpha: 0.14),
        );
    }
    return null;
  }
}

class _PillConfig {
  final String label;
  final Color fg;
  final Color bg;
  _PillConfig({required this.label, required this.fg, required this.bg});
}

class _BadgeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BadgeChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final muted =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: muted.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: muted),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final AssessmentItem item;
  final VoidCallback? onStart;
  const _ActionButton({required this.item, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final label = _labelFor();
    if (label == null) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.brandLight, AppColors.brand],
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onStart,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _labelFor() {
    switch (item.state) {
      case 'planned':
        return 'letsStart'.tr();
      case 'active':
        return 'continueAssessment'.tr();
      case 'passed':
        return item.couldReview ? 'reviewAssessment'.tr() : null;
    }
    return 'letsStart'.tr();
  }
}
