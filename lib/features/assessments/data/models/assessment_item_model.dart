import '../../domain/entities/assessment_item.dart';

class AssessmentItemModel extends AssessmentItem {
  const AssessmentItemModel({
    required super.id,
    super.title,
    super.subject,
    super.state,
    super.score,
    super.maxScore,
    super.startsAt,
    super.endsAt,
    super.createdAt,
  });

  factory AssessmentItemModel.fromJson(Map<String, dynamic> j) {
    return AssessmentItemModel(
      id: (j['_id'] ?? j['id'] ?? '') as String,
      title: (j['title'] ?? j['name']) as String?,
      subject: (j['subject'] ?? j['type']) as String?,
      state: j['state'] as String?,
      score: j['score'] as num?,
      maxScore: (j['maxScore'] ?? j['totalScore']) as num?,
      startsAt: _parseDate(j['startsAt'] ?? j['startDate']),
      endsAt: _parseDate(j['endsAt'] ?? j['endDate']),
      createdAt: _parseDate(j['createdAt']),
    );
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }
}

class AssessmentListPageModel extends AssessmentListPage {
  const AssessmentListPageModel({super.total, super.items});

  factory AssessmentListPageModel.fromJson(dynamic raw) {
    if (raw is! Map) return const AssessmentListPageModel();
    final result = raw['result'];
    final source = result is Map<String, dynamic> ? result : raw;
    final list = source['data'] ?? source['items'];
    return AssessmentListPageModel(
      total: (source['total'] as num?)?.toInt() ?? 0,
      items: list is List<dynamic>
          ? list
              .whereType<Map<String, dynamic>>()
              .map(AssessmentItemModel.fromJson)
              .toList()
          : const [],
    );
  }
}
