import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/question.dart';
import '../../domain/entities/question_detail.dart';
import '../../domain/usecases/get_attempts_usecase.dart';
import '../../domain/usecases/get_comments_usecase.dart';
import '../../domain/usecases/get_question_detail_usecase.dart';
import '../../domain/usecases/post_comment_usecase.dart';
import '../../domain/usecases/submit_answer_usecase.dart';

abstract class QuestionDetailEvent extends Equatable {
  const QuestionDetailEvent();
  @override
  List<Object?> get props => const [];
}

class DetailRequested extends QuestionDetailEvent {
  const DetailRequested();
}

class DetailRefreshed extends QuestionDetailEvent {
  const DetailRefreshed();
}

class AnswerSelected extends QuestionDetailEvent {
  final String answerId;
  const AnswerSelected(this.answerId);
  @override
  List<Object?> get props => [answerId];
}

class AnswerInputChanged extends QuestionDetailEvent {
  final String text;
  const AnswerInputChanged(this.text);
  @override
  List<Object?> get props => [text];
}

class AnswerSubmitted extends QuestionDetailEvent {
  const AnswerSubmitted();
}

class SubmitResultDismissed extends QuestionDetailEvent {
  const SubmitResultDismissed();
}

class CommentDraftChanged extends QuestionDetailEvent {
  final String text;
  const CommentDraftChanged(this.text);
  @override
  List<Object?> get props => [text];
}

class CommentSubmitted extends QuestionDetailEvent {
  const CommentSubmitted();
}

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

class QuestionDetailBloc extends Bloc<QuestionDetailEvent, QuestionDetailState> {
  final String questionId;
  final GetQuestionDetailUseCase getQuestionDetail;
  final SubmitAnswerUseCase submitAnswer;
  final GetAttemptsUseCase getAttempts;
  final GetCommentsUseCase getComments;
  final PostCommentUseCase postComment;

  QuestionDetailBloc({
    required this.questionId,
    required this.getQuestionDetail,
    required this.submitAnswer,
    required this.getAttempts,
    required this.getComments,
    required this.postComment,
  }) : super(const QuestionDetailState()) {
    on<DetailRequested>(_onRequested);
    on<DetailRefreshed>(_onRefreshed);
    on<AnswerSelected>(_onAnswerSelected);
    on<AnswerInputChanged>(_onInputChanged);
    on<AnswerSubmitted>(_onSubmit);
    on<SubmitResultDismissed>(_onResultDismissed);
    on<CommentDraftChanged>(_onCommentDraftChanged);
    on<CommentSubmitted>(_onCommentSubmitted);
  }

  Future<void> _onRequested(
    DetailRequested event,
    Emitter<QuestionDetailState> emit,
  ) =>
      _loadAll(emit, initial: true);

  Future<void> _onRefreshed(
    DetailRefreshed event,
    Emitter<QuestionDetailState> emit,
  ) =>
      _loadAll(emit, initial: false);

  Future<void> _loadAll(
    Emitter<QuestionDetailState> emit, {
    required bool initial,
  }) async {
    emit(state.copyWith(
      loadingDetail: initial,
      loadingAttempts: true,
      loadingComments: true,
      clearDetailError: true,
    ));

    final results = await Future.wait([
      getQuestionDetail(questionId),
      getAttempts(questionId),
      getComments(questionId),
    ]);

    if (emit.isDone) return;

    final detailRes = results[0];
    final attemptsRes = results[1];
    final commentsRes = results[2];

    QuestionDetail? detail = state.detail;
    String? detailError;
    detailRes.when(
      success: (v) => detail = v as QuestionDetail,
      failure: (e) => detailError = _err(e),
    );

    List<Attempt> attempts = state.attempts;
    attemptsRes.when(
      success: (v) => attempts = v as List<Attempt>,
      failure: (_) {},
    );

    List<QuestionComment> comments = state.comments;
    int total = state.commentsTotal;
    commentsRes.when(
      success: (v) {
        final c = v as QuestionComments;
        comments = c.items;
        total = c.total;
      },
      failure: (_) {},
    );

    emit(state.copyWith(
      loadingDetail: false,
      loadingAttempts: false,
      loadingComments: false,
      detail: detail,
      detailError: detailError,
      attempts: attempts,
      comments: comments,
      commentsTotal: total,
    ));
  }

  void _onAnswerSelected(
    AnswerSelected event,
    Emitter<QuestionDetailState> emit,
  ) {
    emit(state.copyWith(
      selectedAnswerId: event.answerId,
      clearLastResult: true,
      clearSubmitError: true,
    ));
  }

  void _onInputChanged(
    AnswerInputChanged event,
    Emitter<QuestionDetailState> emit,
  ) {
    emit(state.copyWith(
      inputText: event.text,
      clearLastResult: true,
      clearSubmitError: true,
    ));
  }

  Future<void> _onSubmit(
    AnswerSubmitted event,
    Emitter<QuestionDetailState> emit,
  ) async {
    final detail = state.detail;
    if (detail == null || !state.canSubmit) return;

    final SubmitAnswer payload;
    switch (detail.type) {
      case QuestionType.singleChoice:
        payload = SubmitAnswer.option(state.selectedAnswerId);
        break;
      case QuestionType.input:
        payload = SubmitAnswer.input(state.inputText.trim());
        break;
      default:
        return;
    }

    emit(state.copyWith(
      submitting: true,
      clearSubmitError: true,
      clearLastResult: true,
    ));

    final res = await submitAnswer(
      questionId: questionId,
      answer: payload,
    );
    if (emit.isDone) return;

    res.when(
      success: (r) => emit(state.copyWith(
        submitting: false,
        lastResult: r,
      )),
      failure: (e) => emit(state.copyWith(
        submitting: false,
        submitError: _err(e),
      )),
    );

    final attemptsRes = await getAttempts(questionId);
    if (emit.isDone) return;
    attemptsRes.when(
      success: (v) => emit(state.copyWith(attempts: v)),
      failure: (_) {},
    );
  }

  void _onResultDismissed(
    SubmitResultDismissed event,
    Emitter<QuestionDetailState> emit,
  ) {
    emit(state.copyWith(clearLastResult: true, clearSubmitError: true));
  }

  void _onCommentDraftChanged(
    CommentDraftChanged event,
    Emitter<QuestionDetailState> emit,
  ) {
    emit(state.copyWith(
      commentDraft: event.text,
      clearCommentError: true,
    ));
  }

  Future<void> _onCommentSubmitted(
    CommentSubmitted event,
    Emitter<QuestionDetailState> emit,
  ) async {
    final draft = state.commentDraft.trim();
    if (draft.isEmpty || state.postingComment) return;

    emit(state.copyWith(postingComment: true, clearCommentError: true));

    final res = await postComment(questionId: questionId, text: draft);
    if (emit.isDone) return;

    await res.when(
      success: (_) async {
        emit(state.copyWith(
          postingComment: false,
          commentDraft: '',
        ));
        final reload = await getComments(questionId);
        if (emit.isDone) return;
        reload.when(
          success: (v) => emit(state.copyWith(
            comments: v.items,
            commentsTotal: v.total,
          )),
          failure: (_) {},
        );
      },
      failure: (e) async {
        emit(state.copyWith(
          postingComment: false,
          commentError: _err(e),
        ));
      },
    );
  }

  String _err(Exception e) => e.toString().replaceFirst('Exception: ', '');
}
