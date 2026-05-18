import 'package:flutter/material.dart';

import '../../domain/entities/assessment_type.dart';
import 'assessment_list_page.dart';

class PlacementsPage extends StatelessWidget {
  const PlacementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AssessmentListPageView(
      type: AssessmentType.placements,
      titleKey: 'placements',
      emptyMessageKey: 'noActivePlacements',
      itemIcon: Icons.place_outlined,
    );
  }
}
