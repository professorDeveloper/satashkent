import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/assessment_section_card.dart';

class AssessmentsPage extends StatelessWidget {
  const AssessmentsPage({super.key});

  static const _sections = <_SectionData>[
    _SectionData(
      route: '/assessments/placements',
      titleKey: 'placements',
      icon: Icons.place_outlined,
    ),
    _SectionData(
      route: '/assessments/level-checks',
      titleKey: 'levelChecks',
      icon: Icons.bar_chart_rounded,
    ),
    _SectionData(
      route: '/assessments/homework',
      titleKey: 'homework',
      icon: Icons.checklist_rounded,
    ),
    _SectionData(
      route: '/assessments/exams',
      titleKey: 'exams',
      icon: Icons.assignment_outlined,
    ),
    _SectionData(
      route: '/assessments/last-dances',
      titleKey: 'lastDances',
      icon: Icons.school_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tabAssessments'.tr()),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _sections.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final s = _sections[i];
          return AssessmentSectionCard(
            title: s.titleKey.tr(),
            icon: s.icon,
            onTap: () => context.push(s.route),
          );
        },
      ),
    );
  }
}

class _SectionData {
  final String route;
  final String titleKey;
  final IconData icon;

  const _SectionData({
    required this.route,
    required this.titleKey,
    required this.icon,
  });
}
