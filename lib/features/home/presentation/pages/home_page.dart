import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/bookmarked_section.dart';
import '../widgets/dashboard_greeting.dart';
import '../widgets/days_left_card.dart';
import '../widgets/goal_score_card.dart';
import '../widgets/goal_score_dialog.dart';
import '../widgets/goal_university_card.dart';
import '../widgets/last_test_card.dart';
import '../widgets/roadmap_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => getIt<HomeBloc>()..add(const HomeRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  Future<void> refresh() async {
    final bloc = context.read<HomeBloc>();
    bloc.add(const HomeRefreshed());
    try {
      await bloc.stream
          .firstWhere((s) => !s.loading)
          .timeout(const Duration(seconds: 15));
    } catch (_) {}
  }

  void showSnack(String text) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> editGoalScore() async {
    final bloc = context.read<HomeBloc>();
    final goal = bloc.state.user?.goalScore;
    final result = await showGoalScoreDialog(
      context,
      initialMath: goal?.math ?? 400,
      initialEnglish: goal?.english ?? 400,
    );
    if (result == null) return;
    bloc.add(HomeGoalScoreSubmitted(math: result.math, english: result.english));
  }

  Future<void> editExamDate() async {
    final bloc = context.read<HomeBloc>();
    final current = bloc.state.user?.tillExam ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
                primary: AppColors.brand,
              ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    bloc.add(HomeExamDateSubmitted(picked));
  }

  void editUniversity() {
    showSnack('comingSoon'.tr());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (a, b) => a.toastNonce != b.toastNonce,
      listener: (context, state) {
        final msg = state.toastMessage;
        if (msg == null || msg.isEmpty) return;
        showSnack(_translate(msg));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('appName'.tr()),
          centerTitle: false,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.brand,
              displacement: 28,
              edgeOffset: 0,
              onRefresh: refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 32),
                children: [
                  DashboardGreeting(name: state.user?.name ?? ''),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RepaintBoundary(
                      child: DaysLeftCard(
                        tillExam: state.user?.tillExam,
                        onEdit: editExamDate,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RepaintBoundary(
                            child: LastTestCard(result: state.lastExam),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RepaintBoundary(
                            child: GoalScoreCard(
                              goalScore: state.user?.goalScore,
                              onEdit: editGoalScore,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RepaintBoundary(
                      child: GoalUniversityCard(
                        imageUrl: state.user?.goalUniversity,
                        onEdit: editUniversity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RepaintBoundary(
                      child: RoadmapCard(
                        onTap: () => showSnack('comingSoon'.tr()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const BookmarkedSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _translate(String key) {
    if (key == 'goalScoreUpdated' || key == 'examDateUpdated') {
      return key.tr();
    }
    return key;
  }
}
