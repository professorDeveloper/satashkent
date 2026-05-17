import '../../domain/entities/question.dart';

class QuestionEnums {
  static QuestionType parseType(String? raw) {
    switch (raw) {
      case 'option':
        return QuestionType.singleChoice;
      case 'multiOption':
        return QuestionType.multiChoice;
      case 'input':
        return QuestionType.input;
      case 'multiInput':
        return QuestionType.multiInput;
      case 'inputOption':
        return QuestionType.inputOption;
      default:
        return QuestionType.unknown;
    }
  }

  static String typeKey(QuestionType t) {
    switch (t) {
      case QuestionType.singleChoice:
        return 'option';
      case QuestionType.multiChoice:
        return 'multiOption';
      case QuestionType.input:
        return 'input';
      case QuestionType.multiInput:
        return 'multiInput';
      case QuestionType.inputOption:
        return 'inputOption';
      case QuestionType.unknown:
        return '';
    }
  }

  static QuestionComplexity parseComplexity(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'EASY':
        return QuestionComplexity.easy;
      case 'MEDIUM':
        return QuestionComplexity.medium;
      case 'HARD':
        return QuestionComplexity.hard;
      default:
        return QuestionComplexity.unknown;
    }
  }

  static String complexityKey(QuestionComplexity c) {
    switch (c) {
      case QuestionComplexity.easy:
        return 'EASY';
      case QuestionComplexity.medium:
        return 'MEDIUM';
      case QuestionComplexity.hard:
        return 'HARD';
      case QuestionComplexity.unknown:
        return '';
    }
  }

  static QuestionStatus parseStatus(String? raw) {
    switch (raw) {
      case 'unattempted':
      case 'new':
        return QuestionStatus.newOne;
      case 'right':
      case 'correct':
        return QuestionStatus.correct;
      case 'wrong':
      case 'incorrect':
        return QuestionStatus.wrong;
      default:
        return QuestionStatus.unknown;
    }
  }

  static String statusKey(QuestionStatus s) {
    switch (s) {
      case QuestionStatus.newOne:
        return 'unattempted';
      case QuestionStatus.correct:
        return 'right';
      case QuestionStatus.wrong:
        return 'wrong';
      case QuestionStatus.unknown:
        return '';
    }
  }

  static QuestionSubject parseSubject(String? raw) {
    switch (raw) {
      case 'math':
        return QuestionSubject.math;
      case 'english':
        return QuestionSubject.english;
      case 'apCalculusAB_BC':
        return QuestionSubject.apCalculus;
      case 'apChemistry':
        return QuestionSubject.apChemistry;
      case 'apCsA':
      case 'apCSA':
        return QuestionSubject.apCsA;
      case 'apMacro':
        return QuestionSubject.apMacro;
      case 'apMicro':
        return QuestionSubject.apMicro;
      case 'apBiology':
        return QuestionSubject.apBiology;
      case 'apStatistics':
        return QuestionSubject.apStatistics;
      case 'apPhysicsC':
        return QuestionSubject.apPhysicsC;
      default:
        return QuestionSubject.unknown;
    }
  }

  static String subjectKey(QuestionSubject s) {
    switch (s) {
      case QuestionSubject.math:
        return 'math';
      case QuestionSubject.english:
        return 'english';
      case QuestionSubject.apCalculus:
        return 'apCalculusAB_BC';
      case QuestionSubject.apChemistry:
        return 'apChemistry';
      case QuestionSubject.apCsA:
        return 'apCsA';
      case QuestionSubject.apMacro:
        return 'apMacro';
      case QuestionSubject.apMicro:
        return 'apMicro';
      case QuestionSubject.apBiology:
        return 'apBiology';
      case QuestionSubject.apStatistics:
        return 'apStatistics';
      case QuestionSubject.apPhysicsC:
        return 'apPhysicsC';
      case QuestionSubject.unknown:
        return '';
    }
  }
}

class QuestionModel extends Question {
  const QuestionModel({
    required super.id,
    super.code,
    super.title,
    super.content,
    super.type,
    super.complexity,
    super.subject,
    super.status,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> j) {
    final raw = j['rawText'] ?? j['title'] ?? j['question'] ?? j['text'];
    final body = j['content'] ?? j['body'] ?? j['description'];
    return QuestionModel(
      id: (j['_id'] ?? j['id'] ?? '') as String,
      code: (j['code'] ?? j['questionCode'] ?? '') as String,
      title: raw is String ? raw : '',
      content: body is String ? body : '',
      type: QuestionEnums.parseType(j['type'] as String?),
      complexity: QuestionEnums.parseComplexity(j['complexityLevel'] as String?),
      subject: QuestionEnums.parseSubject(j['subject'] as String?),
      status: QuestionEnums.parseStatus(j['submissionStatus'] as String?),
    );
  }
}

class QuestionsPageModel extends QuestionsPage {
  const QuestionsPageModel({
    super.items,
    super.total,
    super.page,
    super.limit,
  });

  factory QuestionsPageModel.fromJson(
    dynamic raw, {
    required int page,
    required int limit,
  }) {
    if (raw is! Map) {
      return QuestionsPageModel(page: page, limit: limit);
    }
    final result = raw['result'];
    final source = result is Map<String, dynamic> ? result : raw;
    final list = source['data'] ?? source['questions'] ?? source['items'];
    return QuestionsPageModel(
      page: page,
      limit: limit,
      total: (source['total'] as num?)?.toInt() ?? 0,
      items: list is List<dynamic>
          ? list
              .whereType<Map<String, dynamic>>()
              .map(QuestionModel.fromJson)
              .toList()
          : const [],
    );
  }
}
