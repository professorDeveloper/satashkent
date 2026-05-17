import '../../domain/entities/question_detail.dart';
import 'question_model.dart';

class AnswerModel extends Answer {
  const AnswerModel({
    required super.id,
    super.content,
    super.contentLatex,
    super.latexHtmlLink,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> j) {
    return AnswerModel(
      id: (j['_id'] ?? j['id'] ?? '') as String,
      content: (j['content'] as String?) ?? '',
      contentLatex: (j['contentLatex'] as String?) ?? '',
      latexHtmlLink: (j['latexHtmlLink'] as String?) ?? '',
    );
  }
}

class QuestionDetailModel extends QuestionDetail {
  const QuestionDetailModel({
    required super.id,
    super.title,
    super.content,
    super.contentLatex,
    super.latexHtmlLink,
    super.type,
    super.complexity,
    super.subject,
    super.answers,
  });

  factory QuestionDetailModel.fromJson(Map<String, dynamic> j) {
    final answers = j['answers'];
    return QuestionDetailModel(
      id: (j['_id'] ?? j['id'] ?? '') as String,
      title: (j['title'] as String?) ?? '',
      content: (j['content'] as String?) ?? '',
      contentLatex: (j['contentLatex'] as String?) ?? '',
      latexHtmlLink: (j['latexHtmlLink'] as String?) ?? '',
      type: QuestionEnums.parseType(j['type'] as String?),
      complexity: QuestionEnums.parseComplexity(j['complexityLevel'] as String?),
      subject: QuestionEnums.parseSubject(j['subject'] as String?),
      answers: answers is List
          ? answers
              .whereType<Map<String, dynamic>>()
              .map(AnswerModel.fromJson)
              .toList()
          : const [],
    );
  }
}

class AttemptModel extends Attempt {
  const AttemptModel({required super.answer, required super.isRight});

  factory AttemptModel.fromJson(Map<String, dynamic> j) {
    return AttemptModel(
      answer: _stringify(j['answer'] ?? j['answerId']),
      isRight: j['isRight'] == true,
    );
  }

  static String _stringify(dynamic raw) {
    if (raw == null) return '';
    if (raw is String) return raw;
    if (raw is Map) {
      final inner = raw['answer'] ?? raw['answerId'];
      if (inner is String) return inner;
    }
    return raw.toString();
  }
}

class CommentAuthorModel extends CommentAuthor {
  const CommentAuthorModel({
    required super.id,
    super.name,
    super.image,
  });

  factory CommentAuthorModel.fromJson(Map<String, dynamic> j) {
    return CommentAuthorModel(
      id: (j['_id'] ?? j['id'] ?? '') as String,
      name: (j['name'] as String?) ?? '',
      image: (j['image'] as String?) ?? '',
    );
  }
}

class QuestionCommentModel extends QuestionComment {
  const QuestionCommentModel({
    required super.id,
    super.comment,
    super.createdAt,
    super.author,
    super.hasReply,
  });

  factory QuestionCommentModel.fromJson(Map<String, dynamic> j) {
    final user = j['user'];
    return QuestionCommentModel(
      id: (j['_id'] ?? j['id'] ?? '') as String,
      comment: (j['comment'] as String?) ?? '',
      createdAt: DateTime.tryParse((j['createdAt'] as String?) ?? ''),
      author: user is Map<String, dynamic>
          ? CommentAuthorModel.fromJson(user)
          : const CommentAuthor(id: ''),
      hasReply: j['hasReply'] == true,
    );
  }
}

class QuestionCommentsModel extends QuestionComments {
  const QuestionCommentsModel({super.items, super.total});

  factory QuestionCommentsModel.fromJson(Map<String, dynamic> j) {
    final list = j['data'];
    return QuestionCommentsModel(
      total: (j['total'] as num?)?.toInt() ?? 0,
      items: list is List
          ? list
              .whereType<Map<String, dynamic>>()
              .map(QuestionCommentModel.fromJson)
              .toList()
          : const [],
    );
  }
}

class SubmitResultModel extends SubmitResult {
  const SubmitResultModel({required super.isRight});

  factory SubmitResultModel.fromJson(Map<String, dynamic> j) {
    return SubmitResultModel(isRight: j['isRight'] == true);
  }
}
