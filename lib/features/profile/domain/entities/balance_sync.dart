import 'package:equatable/equatable.dart';

class BalanceSync extends Equatable {
  final bool success;
  final num? balance;
  final DateTime? paidUntil;
  final DateTime? nextAvailableAt;
  final String? remainingTime;
  final String? message;
  final int? code;

  const BalanceSync({
    required this.success,
    this.balance,
    this.paidUntil,
    this.nextAvailableAt,
    this.remainingTime,
    this.message,
    this.code,
  });

  bool get rateLimited => code == 1006;

  @override
  List<Object?> get props => [
        success,
        balance,
        paidUntil,
        nextAvailableAt,
        remainingTime,
        message,
        code,
      ];
}
