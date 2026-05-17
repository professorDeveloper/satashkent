class ReferralStat {
  final int count;
  final num totalDiscount;
  const ReferralStat({this.count = 0, this.totalDiscount = 0});

  factory ReferralStat.fromJson(Map<String, dynamic>? j) {
    if (j == null) return const ReferralStat();
    return ReferralStat(
      count: (j['count'] as num?)?.toInt() ?? 0,
      totalDiscount: (j['totalDiscount'] as num?) ?? 0,
    );
  }
}

class ReferralStats {
  final ReferralStat defaultStat;
  final ReferralStat pendingPayment;
  final ReferralStat approved;
  final ReferralStat requested;
  final ReferralStat completed;
  final ReferralStat rejected;

  const ReferralStats({
    this.defaultStat = const ReferralStat(),
    this.pendingPayment = const ReferralStat(),
    this.approved = const ReferralStat(),
    this.requested = const ReferralStat(),
    this.completed = const ReferralStat(),
    this.rejected = const ReferralStat(),
  });

  factory ReferralStats.fromJson(Map<String, dynamic>? j) {
    if (j == null) return const ReferralStats();
    return ReferralStats(
      defaultStat:
          ReferralStat.fromJson(j['default'] as Map<String, dynamic>?),
      pendingPayment:
          ReferralStat.fromJson(j['pendingPayment'] as Map<String, dynamic>?),
      approved:
          ReferralStat.fromJson(j['approved'] as Map<String, dynamic>?),
      requested:
          ReferralStat.fromJson(j['requested'] as Map<String, dynamic>?),
      completed:
          ReferralStat.fromJson(j['completed'] as Map<String, dynamic>?),
      rejected: ReferralStat.fromJson(j['rejected'] as Map<String, dynamic>?),
    );
  }
}

class ReferralItem {
  final String id;
  final String? name;
  final String? state;
  final num discount;

  const ReferralItem({
    required this.id,
    this.name,
    this.state,
    this.discount = 0,
  });

  factory ReferralItem.fromJson(Map<String, dynamic> j) => ReferralItem(
        id: j['_id'] as String? ?? '',
        name: j['name'] as String?,
        state: j['state'] as String?,
        discount: (j['discount'] as num?) ?? 0,
      );
}

class ReferralListResult {
  final int total;
  final List<ReferralItem> data;
  final ReferralStats stats;

  const ReferralListResult({
    this.total = 0,
    this.data = const [],
    this.stats = const ReferralStats(),
  });

  factory ReferralListResult.fromJson(dynamic raw) {
    if (raw is! Map) return const ReferralListResult();
    final result = raw['result'];
    if (result is! Map<String, dynamic>) return const ReferralListResult();
    return ReferralListResult(
      total: (result['total'] as num?)?.toInt() ?? 0,
      data: (result['data'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ReferralItem.fromJson)
          .toList(),
      stats: ReferralStats.fromJson(result['stats'] as Map<String, dynamic>?),
    );
  }
}
