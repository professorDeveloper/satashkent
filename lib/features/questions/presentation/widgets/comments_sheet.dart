import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/question_detail_bloc.dart';
import 'comments_section.dart';
import 'sheet_header.dart';

Future<void> showCommentsSheet(
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
      child: const _CommentsSheetBody(),
    ),
  );
}

class _CommentsSheetBody extends StatelessWidget {
  const _CommentsSheetBody();

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: FractionallySizedBox(
        heightFactor: 0.85,
        child: BlocBuilder<QuestionDetailBloc, QuestionDetailState>(
          builder: (context, state) {
            final bloc = context.read<QuestionDetailBloc>();
            return Column(
              children: [
                SheetHeader(
                  icon: Icons.chat_bubble_outline_rounded,
                  iconColor: AppColors.brand,
                  title: 'commentsTitle'.tr(),
                  count: state.commentsTotal,
                ),
                Expanded(
                  child: CommentsList(
                    loading: state.loadingComments,
                    comments: state.comments,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
                  child: CommentComposer(
                    draft: state.commentDraft,
                    posting: state.postingComment,
                    error: state.commentError,
                    onChanged: (v) => bloc.add(CommentDraftChanged(v)),
                    onSend: () => bloc.add(const CommentSubmitted()),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
