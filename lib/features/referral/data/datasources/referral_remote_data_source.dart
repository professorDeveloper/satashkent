import 'package:dio/dio.dart';

import '../models/referral_models.dart';

class ReferralRemoteDataSource {
  final Dio dio;
  const ReferralRemoteDataSource({required this.dio});

  Future<String?> getCode() async {
    final response = await dio.get('/referral/code');
    final data = response.data;
    if (data is! Map) return null;
    final result = data['result'];
    if (result is Map<String, dynamic>) {
      return result['referralCode'] as String?;
    }
    return null;
  }

  Future<ReferralListResult> getMyReferrals({int page = 1, int limit = 10}) async {
    final response = await dio.get(
      '/referral/my-referrals',
      queryParameters: {'page': page, 'limit': limit},
    );
    return ReferralListResult.fromJson(response.data);
  }
}
