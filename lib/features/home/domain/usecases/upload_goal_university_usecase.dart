import 'dart:typed_data';

import '../../../../core/error/result.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/home_repository.dart';

class UploadGoalUniversityUseCase {
  final HomeRepository _repository;
  UploadGoalUniversityUseCase(this._repository);

  Future<Result<User>> call({
    required Uint8List bytes,
    required String filename,
    String contentType = 'image/png',
  }) {
    return _repository.uploadAndSetGoalUniversity(
      bytes: bytes,
      filename: filename,
      contentType: contentType,
    );
  }
}
