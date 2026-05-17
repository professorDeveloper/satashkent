import 'dart:typed_data';

import '../../../../core/error/result.dart';
import '../../../auth/domain/entities/user.dart';
import '../entities/assessment_summary.dart';
import '../entities/balance_sync.dart';

abstract class ProfileRepository {
  Future<Result<User>> getProfile();

  Future<Result<List<AssessmentSummary>>> getAssessments();

  Future<Result<BalanceSync>> syncBalance();

  Future<Result<User>> updateProfile({
    required String name,
    required String login,
    String? email,
    String? phone,
  });

  Future<Result<String?>> updateProfileImage({
    required Uint8List bytes,
    String filename,
    String contentType,
  });
}
