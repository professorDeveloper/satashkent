import 'dart:typed_data';

import '../../../../core/error/result.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileImageUseCase {
  final ProfileRepository _repository;
  UpdateProfileImageUseCase(this._repository);

  Future<Result<String?>> call({
    required Uint8List bytes,
    String filename = 'avatar.jpg',
    String contentType = 'image/jpeg',
  }) {
    return _repository.updateProfileImage(
      bytes: bytes,
      filename: filename,
      contentType: contentType,
    );
  }
}
