import '../../domain/entities/last_exam_result.dart';

class LastExamSectionModel extends LastExamSection {
  const LastExamSectionModel({
    super.name,
    super.right,
    super.wrong,
    super.total,
    super.score,
  });

  factory LastExamSectionModel.fromJson(Map<String, dynamic> j) =>
      LastExamSectionModel(
        name: j['name'] as String?,
        right: (j['right'] as num?)?.toInt() ?? 0,
        wrong: (j['wrong'] as num?)?.toInt() ?? 0,
        total: (j['total'] as num?)?.toInt() ?? 0,
        score: (j['score'] as num?)?.toInt(),
      );
}

class LastExamResultModel extends LastExamResult {
  const LastExamResultModel({super.name, super.sections});

  factory LastExamResultModel.fromJson(dynamic raw) {
    if (raw is! Map) return const LastExamResultModel();
    final result = raw['result'];
    final source = result is Map<String, dynamic> ? result : raw;
    return LastExamResultModel(
      name: source['name'] as String?,
      sections: (source['sections'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(LastExamSectionModel.fromJson)
          .toList(),
    );
  }
}
