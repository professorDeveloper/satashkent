import 'package:flutter/material.dart';

import '../../domain/entities/assessment_type.dart';
import 'assessment_list_page.dart';

class ExamsPage extends StatelessWidget {
  const ExamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AssessmentListPageView(
      type: AssessmentType.exams,
      titleKey: 'exams',
      emptyMessageKey: 'noActiveExams',
    );
  }
}
