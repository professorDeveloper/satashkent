import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../assessments/presentation/pages/assessments_page.dart';
import '../../../competitions/presentation/pages/competitions_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../questions/presentation/pages/questions_page.dart';
import '../widgets/main_bottom_nav.dart';
import '../widgets/main_tab_controller.dart';
import '../widgets/main_tab_spec.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  final tabController = getIt<MainTabController>();

  static const tabs = <MainTabSpec>[
    MainTabSpec(Icons.grid_view_rounded, 'tabDashboard'),
    MainTabSpec(Icons.emoji_events_rounded, 'tabCompetitions'),
    MainTabSpec(Icons.assignment_rounded, 'tabAssessments'),
    MainTabSpec(Icons.help_outline_rounded, 'tabQuestions'),
    MainTabSpec(Icons.person_rounded, 'tabProfile'),
  ];

  @override
  void initState() {
    super.initState();
    tabController.addListener(onTabChanged);
  }

  @override
  void dispose() {
    tabController.removeListener(onTabChanged);
    super.dispose();
  }

  void onTabChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localeKey = context.locale.languageCode;
    final activeIndex = tabController.index;
    return PopScope(
      canPop: activeIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (activeIndex != 0) tabController.goto(0);
      },
      child: Scaffold(
        body: IndexedStack(
          index: activeIndex,
          children: [
            HomePage(key: ValueKey('home-$localeKey')),
            CompetitionsPage(key: ValueKey('competitions-$localeKey')),
            AssessmentsPage(key: ValueKey('assessments-$localeKey')),
            QuestionsPage(key: ValueKey('questions-$localeKey')),
            ProfilePage(key: ValueKey('profile-$localeKey')),
          ],
        ),
        bottomNavigationBar: MainBottomNav(
          index: activeIndex,
          tabs: tabs,
          onSelect: tabController.goto,
        ),
      ),
    );
  }
}
