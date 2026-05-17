import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/question_detail_bloc.dart';
import 'attempts_section.dart';
import 'sheet_header.dart';

Future<void> showAttemptsSheet(
  BuildContext context, {
  required QuestionDetailBloc bloc,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: const _AttemptsSheetBody(),
    ),
  );
}

class _AttemptsSheetBody extends StatelessWidget {
  const _AttemptsSheetBody();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.78,
      child: BlocBuilder<QuestionDetailBloc, QuestionDetailState>(
        buildWhen: (a, b) =>
            a.loadingAttempts != b.loadingAttempts ||
            a.attempts != b.attempts ||
            a.detail?.answers != b.detail?.answers,
        builder: (_, state) {
          return Column(
            children: [
              SheetHeader(
                icon: Icons.history_rounded,
                iconColor: AppColors.brand,
                title: 'attemptsTitle'.tr(),
                count: state.attempts.length,
              ),
              Expanded(
                child: AttemptsList(
                  loading: state.loadingAttempts,
                  attempts: state.attempts,
                  options: state.detail?.answers ?? const [],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
