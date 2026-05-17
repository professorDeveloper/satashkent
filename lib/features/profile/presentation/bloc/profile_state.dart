import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/assessment_summary.dart';

abstract class ProfileStatus {}

class ProfileState extends Equatable {
  final bool loading;
  final User? user;
  final List<AssessmentSummary> assessments;
  final bool balanceRefreshing;
  final String? errorMessage;
  final String? balanceMessage;
  final int balanceMessageNonce;

  const ProfileState({
    this.loading = false,
    this.user,
    this.assessments = const [],
    this.balanceRefreshing = false,
    this.errorMessage,
    this.balanceMessage,
    this.balanceMessageNonce = 0,
  });

  bool get hasUser => user != null;

  ProfileState copyWith({
    bool? loading,
    User? user,
    List<AssessmentSummary>? assessments,
    bool? balanceRefreshing,
    String? errorMessage,
    bool clearError = false,
    String? balanceMessage,
    int? balanceMessageNonce,
    bool clearBalanceMessage = false,
  }) {
    return ProfileState(
      loading: loading ?? this.loading,
      user: user ?? this.user,
      assessments: assessments ?? this.assessments,
      balanceRefreshing: balanceRefreshing ?? this.balanceRefreshing,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      balanceMessage:
          clearBalanceMessage ? null : balanceMessage ?? this.balanceMessage,
      balanceMessageNonce: balanceMessageNonce ?? this.balanceMessageNonce,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        user,
        assessments,
        balanceRefreshing,
        errorMessage,
        balanceMessage,
        balanceMessageNonce,
      ];
}
