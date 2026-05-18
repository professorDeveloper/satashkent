import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/assessment_type.dart';
import '../../domain/usecases/get_assessment_list_usecase.dart';
import '../bloc/assessment_list_bloc.dart';
import '../bloc/assessment_list_event.dart';
import '../bloc/assessment_list_state.dart';
import '../widgets/assessment_list_card.dart';
import '../widgets/assessment_list_empty.dart';

class AssessmentListPageView extends StatelessWidget {
  final AssessmentType type;
  final String titleKey;
  final String emptyMessageKey;
  final IconData itemIcon;

  const AssessmentListPageView({
    super.key,
    required this.type,
    required this.titleKey,
    required this.emptyMessageKey,
    required this.itemIcon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssessmentListBloc>(
      create: (_) => AssessmentListBloc(
        getAssessmentList: getIt<GetAssessmentListUseCase>(),
        type: type,
      )..add(const AssessmentListRequested()),
      child: _View(
        titleKey: titleKey,
        emptyMessageKey: emptyMessageKey,
        itemIcon: itemIcon,
      ),
    );
  }
}

class _View extends StatelessWidget {
  final String titleKey;
  final String emptyMessageKey;
  final IconData itemIcon;
  const _View({
    required this.titleKey,
    required this.emptyMessageKey,
    required this.itemIcon,
  });

  Future<void> _refresh(BuildContext context) async {
    final bloc = context.read<AssessmentListBloc>();
    bloc.add(const AssessmentListRefreshed());
    try {
      await bloc.stream
          .firstWhere((s) => !s.loading)
          .timeout(const Duration(seconds: 15));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titleKey.tr())),
      body: BlocBuilder<AssessmentListBloc, AssessmentListState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.brand,
            displacement: 36,
            onRefresh: () => _refresh(context),
            child: _Body(
              state: state,
              emptyMessage: emptyMessageKey.tr(),
              titleFallback: titleKey.tr(),
              itemIcon: itemIcon,
            ),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final AssessmentListState state;
  final String emptyMessage;
  final String titleFallback;
  final IconData itemIcon;

  const _Body({
    required this.state,
    required this.emptyMessage,
    required this.titleFallback,
    required this.itemIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (state.loading && state.page.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 200),
          Center(child: CircularProgressIndicator(color: AppColors.brand)),
        ],
      );
    }
    if (state.errorMessage != null && state.page.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
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
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    }
    if (state.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 40),
          AssessmentListEmpty(message: emptyMessage),
        ],
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: state.page.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) => AssessmentListCard(
        item: state.page.items[i],
        icon: itemIcon,
        fallbackTitle: titleFallback,
      ),
    );
  }
}
