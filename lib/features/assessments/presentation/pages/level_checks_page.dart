import 'package:flutter/material.dart';

import '../../domain/entities/assessment_type.dart';
import 'assessment_list_page.dart';

class LevelChecksPage extends StatelessWidget {
  const LevelChecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AssessmentListPageView(
      type: AssessmentType.levelChecks,
      titleKey: 'levelChecks',
      emptyMessageKey: 'noActiveLevelChecks',
    );
  }
}
