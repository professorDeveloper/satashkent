import '../../domain/entities/level_check.dart';

class LevelCheckModel extends LevelCheck {
  const LevelCheckModel({
    required super.id,
    super.title,
    super.subject,
    super.state,
    super.score,
    super.maxScore,
    super.startsAt,
    super.endsAt,
    super.createdAt,
  });

  factory LevelCheckModel.fromJson(Map<String, dynamic> j) {
    return LevelCheckModel(
      id: (j['_id'] ?? j['id'] ?? '') as String,
      title: (j['title'] ?? j['name']) as String?,
      subject: (j['subject'] ?? j['type']) as String?,
      state: j['state'] as String?,
      score: j['score'] as num?,
      maxScore: (j['maxScore'] ?? j['totalScore']) as num?,
      startsAt: _parseDate(j['startsAt'] ?? j['startDate']),
      endsAt: _parseDate(j['endsAt'] ?? j['endDate']),
      createdAt: _parseDate(j['createdAt']),
    );
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }
}

class LevelChecksPageModel extends LevelChecksPage {
  const LevelChecksPageModel({super.total, super.items});

  factory LevelChecksPageModel.fromJson(dynamic raw) {
    if (raw is! Map) return const LevelChecksPageModel();
    final result = raw['result'];
    final source = result is Map<String, dynamic> ? result : raw;
    final list = source['data'] ?? source['items'];
    return LevelChecksPageModel(
      total: (source['total'] as num?)?.toInt() ?? 0,
      items: list is List<dynamic>
          ? list
              .whereType<Map<String, dynamic>>()
              .map(LevelCheckModel.fromJson)
              .toList()
          : const [],
    );
  }
}
