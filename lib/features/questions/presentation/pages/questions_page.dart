import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/questions_bloc.dart';
import '../bloc/questions_event.dart';
import '../bloc/questions_state.dart';
import '../widgets/question_card.dart';
import '../widgets/questions_filters_sheet.dart';
import '../widgets/questions_search_bar.dart';
import '../widgets/questions_status_dropdown.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuestionsBloc>(
      create: (_) =>
          getIt<QuestionsBloc>()..add(const QuestionsRequested()),
      child: const _QuestionsView(),
    );
  }
}

class _QuestionsView extends StatefulWidget {
  const _QuestionsView();

  @override
  State<_QuestionsView> createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<_QuestionsView> {
  final scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    scroll.removeListener(_onScroll);
    scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scroll.position.pixels >= scroll.position.maxScrollExtent - 200) {
      context.read<QuestionsBloc>().add(const QuestionsNextPageRequested());
    }
  }

  Future<void> _openFilters(QuestionsBloc bloc) async {
    final result = await showQuestionsFiltersSheet(
      context,
      initial: bloc.state.filter,
    );
    if (result == null || !mounted) return;
    bloc.add(QuestionsFilterChanged(result));
  }

  Future<void> _refresh() async {
    final bloc = context.read<QuestionsBloc>();
    final done = bloc.stream.firstWhere((s) => !s.loading);
    bloc.add(const QuestionsRefreshed());
    try {
      await done.timeout(const Duration(seconds: 15));
    } catch (_) {}
  }

  int _activeFilters(QuestionsBloc bloc) {
    final f = bloc.state.filter;
    return f.types.length + f.complexities.length + f.subjects.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tabQuestions'.tr()),
        centerTitle: true,
      ),
      body: BlocBuilder<QuestionsBloc, QuestionsState>(
        builder: (context, state) {
          final bloc = context.read<QuestionsBloc>();
          return RefreshIndicator(
            color: AppColors.brand,
            displacement: 36,
            onRefresh: _refresh,
            child: CustomScrollView(
              controller: scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: QuestionsSearchBar(
                    initial: state.filter.search,
                    activeFilters: _activeFilters(bloc),
                    onChanged: (s) =>
                        bloc.add(QuestionsSearchChanged(s)),
                    onFiltersTap: () => _openFilters(bloc),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                    child: Row(
                      children: [
                        Text(
                          'questions'.tr(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 10),
                        QuestionsTotalBadge(total: state.total),
                        const Spacer(),
                        QuestionsStatusDropdown(
                          value: state.filter.status,
                          onChanged: (s) => bloc.add(QuestionsFilterChanged(
                            state.filter.copyWith(
                              status: s,
                              clearStatus: s == null,
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.loading && state.items.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.brand),
                    ),
                  )
                else if (state.errorMessage != null && state.items.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: () =>
                                bloc.add(const QuestionsRequested()),
                            child: Text('retry'.tr()),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state.items.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.help_outline_rounded,
                            size: 36,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.45),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'questionsEmpty'.tr(),
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) {
                          if (i == state.items.length) {
                            if (state.errorMessage != null) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 8,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      state.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    TextButton(
                                      onPressed: () => bloc.add(
                                        const QuestionsNextPageRequested(),
                                      ),
                                      child: Text('retry'.tr()),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: state.loadingMore
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.brand,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            );
                          }
                          final q = state.items[i];
                          return Padding(
                            padding: EdgeInsets.only(
                              top: i == 0 ? 0 : 10,
                            ),
                            child:  QuestionCard(
                              index: i + 1,
                              question: q,
                              onTap: () async {
                                await context.push('/question/${q.id}');
                                if (!context.mounted) return;
                                bloc.add(const QuestionsRefreshed());
                              },
                            ),
                          );
                        },
                        childCount: state.items.length + 1,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
