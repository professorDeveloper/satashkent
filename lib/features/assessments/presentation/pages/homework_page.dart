import 'package:flutter/material.dart';

import '../../domain/entities/assessment_type.dart';
import 'assessment_list_page.dart';

class HomeworkPage extends StatelessWidget {
  const HomeworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AssessmentListPageView(
      type: AssessmentType.homework,
      titleKey: 'homework',
      emptyMessageKey: 'noActiveHomework',
      itemIcon: Icons.checklist_rounded,
    );
  }
}
