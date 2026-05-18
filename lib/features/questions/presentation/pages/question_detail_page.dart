import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/question_detail.dart';
import '../bloc/question_detail_bloc.dart';
import '../bloc/question_detail_event.dart';
import '../bloc/question_detail_state.dart';
import '../widgets/attempts_sheet.dart';
import '../widgets/comments_sheet.dart';
import '../widgets/input_answer_field.dart';
import '../widgets/option_answer_tile.dart';
import '../widgets/question_html_view.dart';
import '../widgets/question_labels.dart';
import '../widgets/submit_result_banner.dart';

class QuestionDetailPage extends StatelessWidget {
  final String questionId;
  const QuestionDetailPage({super.key, required this.questionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuestionDetailBloc>(
      create: (_) => getIt<QuestionDetailBloc>(param1: questionId)
        ..add(const DetailRequested()),
      child: const _QuestionDetailView(),
    );
  }
}

class _QuestionDetailView extends StatefulWidget {
  const _QuestionDetailView();

  @override
  State<_QuestionDetailView> createState() => _QuestionDetailViewState();
}

class _QuestionDetailViewState extends State<_QuestionDetailView> {
  static const _bannerDuration = Duration(seconds: 3);
  Timer? _dismissTimer;

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  void _scheduleDismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = Timer(_bannerDuration, () {
      if (!mounted) return;
      context.read<QuestionDetailBloc>().add(const SubmitResultDismissed());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('questionDetailTitle'.tr()),
        centerTitle: true,
        actions: [
          BlocBuilder<QuestionDetailBloc, QuestionDetailState>(
            buildWhen: (a, b) => a.attempts.length != b.attempts.length,
            builder: (_, state) => _ActionIcon(
              icon: Icons.history_rounded,
              count: state.attempts.length,
              onTap: () => showAttemptsSheet(
                context,
                bloc: context.read<QuestionDetailBloc>(),
              ),
            ),
          ),
          BlocBuilder<QuestionDetailBloc, QuestionDetailState>(
            buildWhen: (a, b) => a.commentsTotal != b.commentsTotal,
            builder: (_, state) => _ActionIcon(
              icon: Icons.chat_bubble_outline_rounded,
              count: state.commentsTotal,
              onTap: () => showCommentsSheet(
                context,
                bloc: context.read<QuestionDetailBloc>(),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocConsumer<QuestionDetailBloc, QuestionDetailState>(
        listenWhen: (a, b) =>
            a.submitError != b.submitError ||
            a.lastResult != b.lastResult,
        listener: (context, state) {
          if (state.submitError != null &&
              state.submitError!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.submitError!)),
            );
          }
          if (state.lastResult != null) {
            _scheduleDismiss();
          } else {
            _dismissTimer?.cancel();
          }
        },
        builder: (context, state) {
          if (state.loadingDetail && state.detail == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brand),
            );
          }
          if (state.detailError != null && state.detail == null) {
            return _ErrorView(message: state.detailError!);
          }
          final detail = state.detail;
          if (detail == null) {
            return const SizedBox.shrink();
          }
          return QuestionDetailSuccess(state: state, detail: detail);
        },
      ),
    );
  }
}

class QuestionDetailSuccess extends StatelessWidget {
  final QuestionDetailState state;
  final QuestionDetail detail;
  const QuestionDetailSuccess({super.key, required this.state, required this.detail});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<QuestionDetailBloc>();
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            color: AppColors.brand,
            displacement: 36,
            onRefresh: () async {
              bloc.add(const DetailRefreshed());
              try {
                await bloc.stream
                    .firstWhere((s) => !s.loadingDetail)
                    .timeout(const Duration(seconds: 15));
              } catch (_) {}
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              children: [
                _MetaPills(detail: detail),
                const SizedBox(height: 14),
                if (detail.title.isNotEmpty)
                  ...[
                  Text(
                    detail.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (detail.content.isNotEmpty)
                  QuestionHtmlView(html: detail.content),
                const SizedBox(height: 18),
                _SectionLabel(label: 'answerTitle'.tr()),
                const SizedBox(height: 10),
                _AnswerArea(state: state, detail: detail),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: state.lastResult == null
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SubmitResultInfo(
                    isRight: state.lastResult!.isRight,
                    onDismiss: () =>
                        bloc.add(const SubmitResultDismissed()),
                  ),
                ),
        ),
        SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: PrimaryButton(
            label: 'submit'.tr(),
            isLoading: state.submitting,
            onPressed: state.canSubmit
                ? () => bloc.add(const AnswerSubmitted())
                : null,
          ),
        ),
      ],
    );
  }
}

class _AnswerArea extends StatelessWidget {
  final QuestionDetailState state;
  final QuestionDetail detail;
  const _AnswerArea({required this.state, required this.detail});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<QuestionDetailBloc>();
    switch (detail.type) {
      case QuestionType.singleChoice:
        if (detail.answers.isEmpty) {
          return _UnsupportedHint(text: 'answerNoOptions'.tr());
        }
        return Column(
          children: [
            for (var i = 0; i < detail.answers.length; i++) ...[
              OptionAnswerTile(
                answer: detail.answers[i],
                index: i,
                selected: detail.answers[i].id == state.selectedAnswerId,
                onTap: () =>
                    bloc.add(AnswerSelected(detail.answers[i].id)),
              ),
              if (i != detail.answers.length - 1)
                const SizedBox(height: 10),
            ],
          ],
        );
      case QuestionType.input:
        return InputAnswerField(
          value: state.inputText,
          onChanged: (v) => bloc.add(AnswerInputChanged(v)),
        );
      default:
        return _UnsupportedHint(text: 'answerUnsupportedType'.tr());
    }
  }
}

class _MetaPills extends StatelessWidget {
  final QuestionDetail detail;
  const _MetaPills({required this.detail});

  @override
  Widget build(BuildContext context) {
    final typeColor =
        detail.type == QuestionType.input || detail.type == QuestionType.multiInput
            ? const Color(0xFF239B5C)
            : const Color(0xFF2F7BD8);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _Pill(
          color: typeColor,
          icon: QuestionLabels.typeIcon(detail.type),
          label: QuestionLabels.type(detail.type),
          tint: true,
        ),
        _Pill(
          color: QuestionLabels.complexityColor(detail.complexity),
          label: QuestionLabels.complexity(detail.complexity),
          tint: true,
        ),
        _Pill(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          label: QuestionLabels.subject(detail.subject),
          tint: false,
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final Color color;
  final String label;
  final IconData? icon;
  final bool tint;
  const _Pill({
    required this.color,
    required this.label,
    this.icon,
    this.tint = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: tint ? color.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: tint
            ? null
            : Border.all(color: color.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _UnsupportedHint extends StatelessWidget {
  final String text;
  const _UnsupportedHint({required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 0.6,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: scheme.onSurface.withValues(alpha: 0.55),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: scheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<QuestionDetailBloc>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => bloc.add(const DetailRequested()),
              child: Text('retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onTap;
  const _ActionIcon({
    required this.icon,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 22, color: scheme.onSurface),
                if (count > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      constraints: const BoxConstraints(minWidth: 16),
                      decoration: BoxDecoration(
                        color: AppColors.brand,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 1.4,
                        ),
                      ),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
