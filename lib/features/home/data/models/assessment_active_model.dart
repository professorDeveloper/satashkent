import '../../domain/entities/assessment_active.dart';

class AssessmentActiveModel extends AssessmentActive {
  const AssessmentActiveModel({required super.type, super.active});

  factory AssessmentActiveModel.fromJson(Map<String, dynamic> j) =>
      AssessmentActiveModel(
        type: j['type'] as String? ?? '',
        active: (j['active'] as num?)?.toInt() ?? 0,
      );
}
