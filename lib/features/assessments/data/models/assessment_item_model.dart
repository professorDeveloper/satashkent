import '../../domain/entities/assessment_item.dart';

class AssessmentSectionModel extends AssessmentSection {
  const AssessmentSectionModel({
    required super.id,
    required super.name,
    required super.type,
    super.total,
    super.submitted,
    super.state,
  });

  factory AssessmentSectionModel.fromJson(Map<String, dynamic> j) {
    return AssessmentSectionModel(
      id: (j['_id'] ?? j['id'] ?? '') as String,
      name: (j['name'] ?? '') as String,
      type: (j['type'] ?? '') as String,
      total: (j['total'] as num?)?.toInt() ?? 0,
      submitted: (j['submitted'] as num?)?.toInt() ?? 0,
      state: (j['state'] ?? '') as String,
    );
  }
}

class AssessmentItemModel extends AssessmentItem {
  const AssessmentItemModel({
    required super.id,
    super.type,
    super.name,
    super.state,
    super.finishesAt,
    super.total,
    super.right,
    super.sections,
    super.couldReview,
    super.fullScreenRequired,
    super.desmosEnabled,
  });

  factory AssessmentItemModel.fromJson(Map<String, dynamic> j) {
    final rawSections = j['sections'];
    return AssessmentItemModel(
      id: (j['_id'] ?? j['id'] ?? '') as String,
      type: (j['type'] ?? '') as String,
      name: (j['name'] ?? '') as String,
      state: (j['state'] ?? '') as String,
      finishesAt: _parseDate(j['finishesAt']),
      total: (j['total'] as num?)?.toInt() ?? 0,
      right: (j['right'] as num?)?.toInt() ?? 0,
      sections: rawSections is List
          ? rawSections
              .whereType<Map<String, dynamic>>()
              .map(AssessmentSectionModel.fromJson)
              .toList()
          : const [],
      couldReview: j['couldReview'] == true,
      fullScreenRequired: j['fullScreenRequired'] == true,
      desmosEnabled: j['desmosEnabled'] == true,
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
      items: list is List
          ? list
              .whereType<Map<String, dynamic>>()
              .map(AssessmentItemModel.fromJson)
              .toList()
          : const [],
    );
  }
}
