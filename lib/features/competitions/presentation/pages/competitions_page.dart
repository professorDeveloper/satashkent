import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/competitions_bloc.dart';
import '../bloc/competitions_event.dart';
import '../bloc/competitions_state.dart';
import '../widgets/competition_card.dart';
import '../widgets/competitions_empty.dart';

class CompetitionsPage extends StatelessWidget {
  const CompetitionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompetitionsBloc>(
      create: (_) => getIt<CompetitionsBloc>()..add(const CompetitionsRequested()),
      child: const _CompetitionsView(),
    );
  }
}

class _CompetitionsView extends StatefulWidget {
  const _CompetitionsView();

  @override
  State<_CompetitionsView> createState() => _CompetitionsViewState();
}

class _CompetitionsViewState extends State<_CompetitionsView> {
  Future<void> refresh() async {
    final bloc = context.read<CompetitionsBloc>();
    bloc.add(const CompetitionsRefreshed());
    try {
      await bloc.stream
          .firstWhere((s) => !s.loading)
          .timeout(const Duration(seconds: 15));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tabCompetitions'.tr()),
        centerTitle: true,
      ),
      body: BlocBuilder<CompetitionsBloc, CompetitionsState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.brand,
            displacement: 36,
            onRefresh: refresh,
            child: _Body(state: state),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final CompetitionsState state;
  const _Body({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.errorMessage != null && state.page.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
        children: [
          Center(
            child: Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => context
                  .read<CompetitionsBloc>()
                  .add(const CompetitionsRequested()),
              child: Text('retry'.tr()),
            ),
          ),
        ],
      );
    }
    if (state.page.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: const [CompetitionsEmpty()],
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      itemCount: state.page.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => CompetitionCard(item: state.page.items[i]),
    );
  }
}
