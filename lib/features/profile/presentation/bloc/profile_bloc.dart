import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/hive_service.dart';
import '../../domain/usecases/get_assessments_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/sync_balance_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final GetAssessmentsUseCase getAssessmentsUseCase;
  final SyncBalanceUseCase syncBalanceUseCase;
  final HiveService hiveService;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.getAssessmentsUseCase,
    required this.syncBalanceUseCase,
    required this.hiveService,
  }) : super(ProfileState(user: hiveService.getUser())) {
    on<ProfileRequested>(_onRequested);
    on<ProfileRefreshed>(_onRefreshed);
    on<ProfileBalanceRefreshed>(_onBalanceRefreshed);
    on<ProfileUserPatched>(_onUserPatched);
  }

  Future<void> _load(Emitter<ProfileState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    final profileFuture = getProfileUseCase();
    final assessFuture = getAssessmentsUseCase();
    final profileRes = await profileFuture;
    final assessRes = await assessFuture;
    String? error;
    profileRes.when(
      success: (_) {},
      failure: (e) => error = e.toString().replaceFirst('Exception: ', ''),
    );
    final user = profileRes.getOrNull();
    final assessments = assessRes.getOrNull() ?? state.assessments;
    final img = user?.image;
    if (img != null && img.isNotEmpty) {
      await CachedNetworkImage.evictFromCache(img);
      imageCache.evict(NetworkImage(img));
    }
    emit(state.copyWith(
      loading: false,
      user: user,
      assessments: assessments,
      errorMessage: error,
      clearError: error == null,
    ));
  }

  Future<void> _onRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) =>
      _load(emit);

  Future<void> _onRefreshed(
    ProfileRefreshed event,
    Emitter<ProfileState> emit,
  ) =>
      _load(emit);

  Future<void> _onBalanceRefreshed(
    ProfileBalanceRefreshed event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.balanceRefreshing) return;
    emit(state.copyWith(balanceRefreshing: true, clearBalanceMessage: true));
    final result = await syncBalanceUseCase();
    final sync = result.getOrNull();
    if (sync == null) {
      emit(state.copyWith(
        balanceRefreshing: false,
        balanceMessage:
            result.errorOrNull()?.toString().replaceFirst('Exception: ', ''),
        balanceMessageNonce: state.balanceMessageNonce + 1,
      ));
      return;
    }
    if (sync.rateLimited) {
      emit(state.copyWith(
        balanceRefreshing: false,
        balanceMessage: sync.remainingTime ?? sync.message,
        balanceMessageNonce: state.balanceMessageNonce + 1,
      ));
      return;
    }
    if (sync.success) {
      final refreshed = await getProfileUseCase();
      final user = refreshed.getOrNull() ?? hiveService.getUser();
      emit(state.copyWith(
        balanceRefreshing: false,
        user: user,
        clearBalanceMessage: true,
      ));
      return;
    }
    emit(state.copyWith(
      balanceRefreshing: false,
      balanceMessage: sync.message,
      balanceMessageNonce: state.balanceMessageNonce + 1,
    ));
  }

  void _onUserPatched(ProfileUserPatched event, Emitter<ProfileState> emit) {
    emit(state.copyWith(user: event.user));
  }
}
