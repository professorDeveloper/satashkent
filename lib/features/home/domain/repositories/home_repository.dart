import 'dart:typed_data';

import '../../../../core/error/result.dart';
import '../../../auth/domain/entities/user.dart';
import '../entities/assessment_active.dart';
import '../entities/last_exam_result.dart';

abstract class HomeRepository {
  Future<Result<List<AssessmentActive>>> getAssessmentsSummary();
  Future<Result<LastExamResult>> getLastExamResult();
  Future<Result<User>> setGoalScore({required int math, required int english});
  Future<Result<User>> setGoalUniversity(String url);
  Future<Result<User>> setExamDate(DateTime date);
  Future<Result<User>> uploadAndSetGoalUniversity({
    required Uint8List bytes,
    required String filename,
    String contentType,
  });
}
