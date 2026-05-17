import '../../domain/entities/assessment_summary.dart';

class AssessmentRecentModel extends AssessmentRecent {
  const AssessmentRecentModel({
    required super.id,
    super.name,
    super.state,
    super.right,
    super.wrong,
    super.total,
    super.finishedAt,
  });

  factory AssessmentRecentModel.fromJson(Map<String, dynamic> j) =>
      AssessmentRecentModel(
        id: j['_id'] as String? ?? '',
        name: j['name'] as String?,
        state: j['state'] as String?,
        right: (j['right'] as num?)?.toInt() ?? 0,
        wrong: (j['wrong'] as num?)?.toInt() ?? 0,
        total: (j['total'] as num?)?.toInt() ?? 0,
        finishedAt: j['finishedAt'] is String
            ? DateTime.tryParse(j['finishedAt'] as String)
            : null,
      );
}

class AssessmentSummaryModel extends AssessmentSummary {
  const AssessmentSummaryModel({
    required super.type,
    super.newCount,
    super.active,
    super.passed,
    super.recent,
  });

  factory AssessmentSummaryModel.fromJson(Map<String, dynamic> j) =>
      AssessmentSummaryModel(
        type: j['type'] as String? ?? '',
        newCount: (j['new'] as num?)?.toInt() ?? 0,
        active: (j['active'] as num?)?.toInt() ?? 0,
        passed: (j['passed'] as num?)?.toInt() ?? 0,
        recent: (j['recent'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(AssessmentRecentModel.fromJson)
            .toList(),
      );
}
