import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
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
import '../widgets/logout_confirm_dialog.dart';
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

  Future<void> confirmLogout() async {
    final ok = await showLogoutConfirm(context);
    if (!ok || !mounted) return;
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
        appBar: AppBar(
          title: Text('profile'.tr()),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'settings'.tr(),
              icon: const Icon(Icons.settings_outlined),
              onPressed: openSettings,
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.brand,
              displacement: 28,
              edgeOffset: 0,
              onRefresh: refresh,
              child: _Body(
                state: state,
                onRefreshBalance: refreshBalance,
                onLogout: confirmLogout,
                onEdit: openEdit,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ProfileState state;
  final VoidCallback onRefreshBalance;
  final VoidCallback onLogout;
  final VoidCallback onEdit;

  const _Body({
    required this.state,
    required this.onRefreshBalance,
    required this.onLogout,
    required this.onEdit,
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
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 200),
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
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
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
          child: LogoutBigButton(onTap: onLogout),
        ),
      ],
    );
  }
}
