import 'package:flutter/material.dart';

import '../../domain/entities/assessment_type.dart';
import 'assessment_list_page.dart';

class LastDancesPage extends StatelessWidget {
  const LastDancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AssessmentListPageView(
      type: AssessmentType.lastDances,
      titleKey: 'lastDances',
      emptyMessageKey: 'noActiveLastDances',
      itemIcon: Icons.school_outlined,
    );
  }
}
