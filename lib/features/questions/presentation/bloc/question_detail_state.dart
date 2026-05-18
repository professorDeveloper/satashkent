import 'package:equatable/equatable.dart';

import '../../domain/entities/question.dart';
import '../../domain/entities/question_detail.dart';

class QuestionDetailState extends Equatable {
  final bool loadingDetail;
  final String? detailError;
  final QuestionDetail? detail;

  final String? selectedAnswerId;
  final String inputText;

  final bool submitting;
  final SubmitResult? lastResult;
  final String? submitError;

  final bool loadingAttempts;
  final List<Attempt> attempts;

  final bool loadingComments;
  final List<QuestionComment> comments;
  final int commentsTotal;

  final String commentDraft;
  final bool postingComment;
  final String? commentError;

  const QuestionDetailState({
    this.loadingDetail = false,
    this.detailError,
    this.detail,
    this.selectedAnswerId,
    this.inputText = '',
    this.submitting = false,
    this.lastResult,
    this.submitError,
    this.loadingAttempts = false,
    this.attempts = const [],
    this.loadingComments = false,
    this.comments = const [],
    this.commentsTotal = 0,
    this.commentDraft = '',
    this.postingComment = false,
    this.commentError,
  });

  bool get canSubmit {
    if (submitting || detail == null) return false;
    switch (detail!.type) {
      case QuestionType.singleChoice:
        return selectedAnswerId != null;
      case QuestionType.input:
        return inputText.trim().isNotEmpty;
      default:
        return false;
    }
  }

  bool get canPostComment =>
      !postingComment && commentDraft.trim().isNotEmpty;

  QuestionDetailState copyWith({
    bool? loadingDetail,
    String? detailError,
    bool clearDetailError = false,
    QuestionDetail? detail,
    String? selectedAnswerId,
    bool clearSelectedAnswer = false,
    String? inputText,
    bool? submitting,
    SubmitResult? lastResult,
    bool clearLastResult = false,
    String? submitError,
    bool clearSubmitError = false,
    bool? loadingAttempts,
    List<Attempt>? attempts,
    bool? loadingComments,
    List<QuestionComment>? comments,
    int? commentsTotal,
    String? commentDraft,
    bool? postingComment,
    String? commentError,
    bool clearCommentError = false,
  }) {
    return QuestionDetailState(
      loadingDetail: loadingDetail ?? this.loadingDetail,
      detailError: clearDetailError ? null : detailError ?? this.detailError,
      detail: detail ?? this.detail,
      selectedAnswerId: clearSelectedAnswer
          ? null
          : selectedAnswerId ?? this.selectedAnswerId,
      inputText: inputText ?? this.inputText,
      submitting: submitting ?? this.submitting,
      lastResult: clearLastResult ? null : lastResult ?? this.lastResult,
      submitError: clearSubmitError ? null : submitError ?? this.submitError,
      loadingAttempts: loadingAttempts ?? this.loadingAttempts,
      attempts: attempts ?? this.attempts,
      loadingComments: loadingComments ?? this.loadingComments,
      comments: comments ?? this.comments,
      commentsTotal: commentsTotal ?? this.commentsTotal,
      commentDraft: commentDraft ?? this.commentDraft,
      postingComment: postingComment ?? this.postingComment,
      commentError: clearCommentError ? null : commentError ?? this.commentError,
    );
  }

  @override
  List<Object?> get props => [
        loadingDetail,
        detailError,
        detail,
        selectedAnswerId,
        inputText,
        submitting,
        lastResult,
        submitError,
        loadingAttempts,
        attempts,
        loadingComments,
        comments,
        commentsTotal,
        commentDraft,
        postingComment,
        commentError,
      ];
}
