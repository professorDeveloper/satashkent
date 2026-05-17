import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/blur_app_bar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../domain/entities/assessment_summary.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/assessment_section.dart';
import '../widgets/balance_card.dart';
import '../widgets/groups_card.dart';
import '../widgets/logout_big_button.dart';
import '../widgets/profile_header_row.dart';
import '../widgets/referral_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => getIt<ProfileBloc>()..add(const ProfileRequested()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
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
    final bloc = context.read<ProfileBloc>();
    bloc.add(const ProfileRefreshed());
    try {
      await bloc.stream
          .firstWhere((s) => !s.loading)
          .timeout(const Duration(seconds: 15));
    } catch (_) {}
  }

  Future<void> openEdit() async {
    final updated = await context.push<bool>('/edit-profile');
    if (!mounted) return;
    if (updated == true) {
      context.read<ProfileBloc>().add(const ProfileRefreshed());
    }
  }

  void openSettings() => context.push('/settings');

  void refreshBalance() =>
      context.read<ProfileBloc>().add(const ProfileBalanceRefreshed());

  void confirmLogout() {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }

  void showSnack(String text) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (a, b) => a.balanceMessageNonce != b.balanceMessageNonce,
      listener: (context, state) {
        final msg = state.balanceMessage;
        if (msg != null && msg.isNotEmpty) showSnack(msg);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: BlurAppBar(title: 'profile'.tr(), scrolled: scrolled),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final topInset =
                MediaQuery.of(context).padding.top + kToolbarHeight - 12;
            return RefreshIndicator(
              color: AppColors.brand,
              displacement: 20,
              onRefresh: refresh,
              child: _Body(
                controller: scroll,
                topInset: topInset,
                state: state,
                onRefreshBalance: refreshBalance,
                onLogout: confirmLogout,
                onEdit: openEdit,
                onSettings: openSettings,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ScrollController controller;
  final double topInset;
  final ProfileState state;
  final VoidCallback onRefreshBalance;
  final VoidCallback onLogout;
  final VoidCallback onEdit;
  final VoidCallback onSettings;

  const _Body({
    required this.controller,
    required this.topInset,
    required this.state,
    required this.onRefreshBalance,
    required this.onLogout,
    required this.onEdit,
    required this.onSettings,
  });

  AssessmentSummary? _byType(String type) {
    for (final e in state.assessments) {
      if (e.type == type) return e;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = state.user;
    if (user == null) {
      return ListView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: topInset + 100),
          if (state.loading)
            const Center(child: CircularProgressIndicator(color: AppColors.brand))
          else
            Center(
              child: TextButton(
                onPressed: () => context
                    .read<ProfileBloc>()
                    .add(const ProfileRequested()),
                child: Text('retry'.tr()),
              ),
            ),
        ],
      );
    }
    return ListView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: topInset, bottom: 32),
      children: [
        ProfileHeaderRow(user: user, onEdit: onEdit),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RepaintBoundary(
            child: BalanceCard(
              balance: user.studentBalance,
              nextPayment: user.paidUntil,
              refreshing: state.balanceRefreshing,
              onRefresh: onRefreshBalance,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: RepaintBoundary(child: GroupsCard()),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: RepaintBoundary(child: ReferralCard()),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AssessmentSection(
            title: 'levelChecks'.tr(),
            icon: Icons.bar_chart_rounded,
            data: _byType('levelCheck'),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AssessmentSection(
            title: 'homework'.tr(),
            icon: Icons.menu_book_rounded,
            data: _byType('homework'),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AssessmentSection(
            title: 'exams'.tr(),
            icon: Icons.school_rounded,
            data: _byType('exam'),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AssessmentSection(
            title: 'lastDances'.tr(),
            icon: Icons.emoji_events_rounded,
            data: _byType('finalExam'),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AssessmentSection(
            title: 'placements'.tr(),
            icon: Icons.assignment_turned_in_rounded,
            data: _byType('placement'),
          ),
        ),
        const SizedBox(height: 22),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _SettingsTile(onTap: onSettings),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LogoutBigButton(onTap: onLogout),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final VoidCallback onTap;
  const _SettingsTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = scheme.onSurface;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border:
                Border.all(color: Theme.of(context).dividerColor, width: 0.6),
          ),
          child: Row(
            children: [
              Icon(Icons.settings_outlined, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'settings'.tr(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: color.withValues(alpha: 0.6),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
