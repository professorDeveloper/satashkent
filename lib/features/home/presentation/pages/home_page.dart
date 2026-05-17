import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../main_shell/presentation/widgets/main_tab_controller.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/bookmarked_section.dart';
import '../widgets/competitions_card.dart';
import '../widgets/days_left_card.dart';
import '../widgets/exam_date_dialog.dart';
import '../widgets/goal_score_card.dart';
import '../widgets/goal_score_dialog.dart';
import '../widgets/goal_university_card.dart';
import '../widgets/last_test_card.dart';
import '../widgets/quick_access_section.dart';

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
  final scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    getIt<NotificationsBloc>().add(const NotificationsRequested());
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  Future<void> refresh() async {
    final bloc = context.read<HomeBloc>();
    bloc.add(const HomeRefreshed());
    getIt<NotificationsBloc>().add(const NotificationsRefreshed());
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
    if (result == null || !mounted) return;
    bloc.add(
      HomeGoalScoreSubmitted(math: result.math, english: result.english),
    );
  }

  Future<void> editExamDate() async {
    final bloc = context.read<HomeBloc>();
    final picked = await showExamDateDialog(
      context,
      initial: bloc.state.user?.tillExam,
    );
    if (picked == null || !mounted) return;
    bloc.add(HomeExamDateSubmitted(picked));
  }

  void openNotifications() => context.push('/notifications');

  void openCompetitions() => getIt<MainTabController>().goto(1);

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (a, b) => a.toastNonce != b.toastNonce,
      listener: (context, state) {
        final msg = state.toastMessage;
        if (msg == null || msg.isEmpty) return;
        showSnack(_resolveMessage(msg));
      },
      child: Scaffold(
        appBar: _HomeAppBar(
          name: context.select<HomeBloc, String?>((b) => b.state.user?.name),
          onNotifications: openNotifications,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.brand,
              displacement: 36,
              onRefresh: refresh,
              child: _DashboardList(
                controller: scroll,
                state: state,
                onEditGoalScore: editGoalScore,
                onEditExamDate: editExamDate,
                onOpenCompetitions: openCompetitions,
              ),
            );
          },
        ),
      ),
    );
  }

  String _resolveMessage(String key) {
    const translatable = {'goalScoreUpdated', 'examDateUpdated'};
    return translatable.contains(key) ? key.tr() : key;
  }
}

class _DashboardList extends StatelessWidget {
  final ScrollController controller;
  final HomeState state;
  final VoidCallback onEditGoalScore;
  final VoidCallback onEditExamDate;
  final VoidCallback onOpenCompetitions;

  const _DashboardList({
    required this.controller,
    required this.state,
    required this.onEditGoalScore,
    required this.onEditExamDate,
    required this.onOpenCompetitions,
  });

  @override
  Widget build(BuildContext context) {
    final user = state.user;
    return ListView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RepaintBoundary(
            child: DaysLeftCard(
              tillExam: user?.tillExam,
              onEdit: onEditExamDate,
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
                    goalScore: user?.goalScore,
                    onEdit: onEditGoalScore,
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
            child: GoalUniversityCard(imageUrl: user?.goalUniversity),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RepaintBoundary(
            child: CompetitionsCard(onTap: onOpenCompetitions),
          ),
        ),
        const SizedBox(height: 12),
        QuickAccessSection(
          assessments: state.assessments,
          onTap: (_) {},
        ),
        const SizedBox(height: 22),
        const BookmarkedSection(),
      ],
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? name;
  final VoidCallback onNotifications;

  const _HomeAppBar({required this.name, required this.onNotifications});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 16,
      title: Row(
        children: [
          const Text('👋', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '${'hi'.tr()} ${(name ?? '').trim()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      actions: [
        _NotificationsButton(onTap: onNotifications),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _NotificationsButton extends StatelessWidget {
  final VoidCallback onTap;
  const _NotificationsButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsBloc>.value(
      value: getIt<NotificationsBloc>(),
      child: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          final count = state.page.newTotal;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                tooltip: 'notifications'.tr(),
                onPressed: onTap,
                icon: const Icon(Icons.notifications_none_rounded),
              ),
              if (count > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    constraints: const BoxConstraints(minWidth: 16),
                    decoration: BoxDecoration(
                      color: AppColors.brand,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      count > 99 ? '99+' : count.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
