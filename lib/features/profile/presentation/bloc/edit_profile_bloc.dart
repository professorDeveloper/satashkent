import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/hive_service.dart';
import '../../domain/usecases/update_profile_image_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final UpdateProfileImageUseCase updateProfileImageUseCase;
  final HiveService hiveService;

  EditProfileBloc({
    required this.updateProfileUseCase,
    required this.updateProfileImageUseCase,
    required this.hiveService,
  }) : super(EditProfileState(imageUrl: hiveService.getUser()?.image)) {
    on<EditProfileStarted>(_onStarted);
    on<EditProfileSubmitted>(_onSubmitted);
    on<EditProfileImagePicked>(_onImagePicked);
  }

  void _onStarted(EditProfileStarted event, Emitter<EditProfileState> emit) {
    emit(EditProfileState(imageUrl: hiveService.getUser()?.image));
  }

  Future<void> _onSubmitted(
    EditProfileSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(saving: true, clearError: true, clearInfo: true));
    final result = await updateProfileUseCase(
      name: event.name,
      login: event.login,
      email: event.email,
      phone: event.phone,
    );
    result.when(
      success: (user) => emit(state.copyWith(
        saving: false,
        savedUser: user,
        infoMessage: 'profileUpdated',
        messageNonce: state.messageNonce + 1,
      )),
      failure: (e) => emit(state.copyWith(
        saving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        messageNonce: state.messageNonce + 1,
      )),
    );
  }

  Future<void> _onImagePicked(
    EditProfileImagePicked event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(uploading: true, clearError: true, clearInfo: true));
    final result = await updateProfileImageUseCase(bytes: event.bytes);
    result.when(
      success: (url) => emit(state.copyWith(
        uploading: false,
        imageUrl: url ?? state.imageUrl,
        infoMessage: 'photoUpdated',
        messageNonce: state.messageNonce + 1,
      )),
      failure: (e) => emit(state.copyWith(
        uploading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        messageNonce: state.messageNonce + 1,
      )),
    );
  }
}
