import '../../domain/entities/balance_sync.dart';

class BalanceSyncModel extends BalanceSync {
  const BalanceSyncModel({
    required super.success,
    super.balance,
    super.paidUntil,
    super.nextAvailableAt,
    super.remainingTime,
    super.message,
    super.code,
  });

  factory BalanceSyncModel.fromJson(dynamic raw) {
    if (raw is! Map) {
      return const BalanceSyncModel(
        success: false,
        message: 'Invalid response',
      );
    }
    final success = raw['success'] == true;
    final result = raw['result'];
    final data = raw['data'];
    return BalanceSyncModel(
      success: success,
      balance: result is Map<String, dynamic>
          ? (result['studentBalance'] as num?)
          : null,
      paidUntil: result is Map<String, dynamic> && result['paidUntil'] is String
          ? DateTime.tryParse(result['paidUntil'] as String)
          : null,
      nextAvailableAt:
          data is Map<String, dynamic> && data['nextAvailableAt'] is String
              ? DateTime.tryParse(data['nextAvailableAt'] as String)
              : null,
      remainingTime: data is Map<String, dynamic>
          ? data['remainingTime'] as String?
          : null,
      message: raw['message'] as String?,
      code: (raw['code'] as num?)?.toInt(),
    );
  }
}
