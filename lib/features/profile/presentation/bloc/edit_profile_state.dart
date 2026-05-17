import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user.dart';

class EditProfileState extends Equatable {
  final String? imageUrl;
  final bool saving;
  final bool uploading;
  final User? savedUser;
  final String? errorMessage;
  final String? infoMessage;
  final int messageNonce;

  const EditProfileState({
    this.imageUrl,
    this.saving = false,
    this.uploading = false,
    this.savedUser,
    this.errorMessage,
    this.infoMessage,
    this.messageNonce = 0,
  });

  EditProfileState copyWith({
    String? imageUrl,
    bool? saving,
    bool? uploading,
    User? savedUser,
    String? errorMessage,
    String? infoMessage,
    int? messageNonce,
    bool clearError = false,
    bool clearInfo = false,
    bool clearSavedUser = false,
  }) {
    return EditProfileState(
      imageUrl: imageUrl ?? this.imageUrl,
      saving: saving ?? this.saving,
      uploading: uploading ?? this.uploading,
      savedUser: clearSavedUser ? null : savedUser ?? this.savedUser,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      infoMessage: clearInfo ? null : infoMessage ?? this.infoMessage,
      messageNonce: messageNonce ?? this.messageNonce,
    );
  }

  @override
  List<Object?> get props => [
        imageUrl,
        saving,
        uploading,
        savedUser?.id,
        savedUser?.name,
        savedUser?.image,
        errorMessage,
        infoMessage,
        messageNonce,
      ];
}
