import '../../domain/entities/competition.dart';

class CompetitionModel extends Competition {
  const CompetitionModel({
    required super.id,
    required super.title,
    super.description,
    super.image,
    super.state,
    super.startsAt,
    super.endsAt,
    super.participants,
    super.prize,
  });

  factory CompetitionModel.fromJson(Map<String, dynamic> j) {
    return CompetitionModel(
      id: (j['_id'] ?? j['id'] ?? '') as String,
      title: (j['name'] ?? j['title'] ?? '') as String,
      description: (j['description'] ?? j['details']) as String?,
      image: (j['image'] ?? j['cover'] ?? j['banner']) as String?,
      state: j['state'] as String?,
      startsAt: _parseDate(j['startsAt'] ?? j['startDate']),
      endsAt: _parseDate(j['endsAt'] ?? j['endDate']),
      participants:
          (j['participants'] as num?)?.toInt() ??
              (j['totalParticipants'] as num?)?.toInt() ??
              0,
      prize: (j['prize'] as num?) ?? (j['reward'] as num?),
    );
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }
}

class CompetitionPageModel extends CompetitionPage {
  const CompetitionPageModel({super.total, super.items});

  factory CompetitionPageModel.fromJson(dynamic raw) {
    if (raw is! Map) return const CompetitionPageModel();
    final result = raw['result'];
    final source = result is Map<String, dynamic> ? result : raw;
    final list = source['data'] ?? source['competitions'] ?? source['items'];
    return CompetitionPageModel(
      total: (source['total'] as num?)?.toInt() ?? 0,
      items: list is List<dynamic>
          ? list
              .whereType<Map<String, dynamic>>()
              .map(CompetitionModel.fromJson)
              .toList()
          : const [],
    );
  }
}
