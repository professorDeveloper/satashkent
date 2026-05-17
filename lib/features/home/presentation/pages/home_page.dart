import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/bookmarked_section.dart';
import '../widgets/days_left_card.dart';
import '../widgets/exam_date_dialog.dart';
import '../widgets/goal_score_card.dart';
import '../widgets/goal_score_dialog.dart';
import '../widgets/goal_university_card.dart';
import '../widgets/last_test_card.dart';
import '../widgets/roadmap_card.dart';
import '../widgets/roadmap_locked_dialog.dart';

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
  bool scrolled = false;

  @override
  void initState() {
    super.initState();
    scroll.addListener(onScroll);
  }

  @override
  void dispose() {
    scroll.removeListener(onScroll);
    scroll.dispose();
    super.dispose();
  }

  void onScroll() {
    final next = scroll.offset > 6;
    if (next != scrolled) setState(() => scrolled = next);
  }

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

  void openNotifications() => showSnack('comingSoon'.tr());

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
        extendBodyBehindAppBar: true,
        appBar: _HomeAppBar(
          scrolled: scrolled,
          name: context.select<HomeBloc, String?>((b) => b.state.user?.name),
          onNotifications: openNotifications,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.brand,
              displacement: 28,
              edgeOffset: 0,
              onRefresh: refresh,
              child: _DashboardList(
                controller: scroll,
                state: state,
                onEditGoalScore: editGoalScore,
                onEditExamDate: editExamDate,
                onTapRoadmap: () => showRoadmapLockedDialog(context),
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
  final VoidCallback onTapRoadmap;

  const _DashboardList({
    required this.controller,
    required this.state,
    required this.onEditGoalScore,
    required this.onEditExamDate,
    required this.onTapRoadmap,
  });

  @override
  Widget build(BuildContext context) {
    final topPad =
        MediaQuery.of(context).padding.top + kToolbarHeight - 12;
    final user = state.user;
    return ListView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(0, topPad, 0, 32),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RepaintBoundary(
            child: DaysLeftCard(
              tillExam: user?.tillExam,
              onEdit: onEditExamDate,
            ),
          ),
        ).animate().fadeIn(duration: 320.ms).slideY(begin: 0.08, end: 0),
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
        ).animate(delay: 80.ms).fadeIn(duration: 320.ms).slideY(
              begin: 0.08,
              end: 0,
            ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RepaintBoundary(
            child: GoalUniversityCard(imageUrl: user?.goalUniversity),
          ),
        ).animate(delay: 160.ms).fadeIn(duration: 320.ms).slideY(
              begin: 0.08,
              end: 0,
            ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RepaintBoundary(child: RoadmapCard(onTap: onTapRoadmap)),
        ).animate(delay: 240.ms).fadeIn(duration: 320.ms).slideY(
              begin: 0.08,
              end: 0,
            ),
        const SizedBox(height: 22),
        const BookmarkedSection()
            .animate(delay: 320.ms)
            .fadeIn(duration: 320.ms),
      ],
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool scrolled;
  final String? name;
  final VoidCallback onNotifications;

  const _HomeAppBar({
    required this.scrolled,
    required this.name,
    required this.onNotifications,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      titleSpacing: 16,
      flexibleSpace: scrolled
          ? RepaintBoundary(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: scaffoldBg.withValues(alpha: 0.78),
                  ),
                ),
              ),
            )
          : null,
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
        IconButton(
          tooltip: 'notifications'.tr(),
          onPressed: onNotifications,
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
