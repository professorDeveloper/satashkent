import '../../domain/entities/user.dart';

class GoalScoreModel extends GoalScore {
  const GoalScoreModel({required super.math, required super.english});

  factory GoalScoreModel.fromJson(Map<String, dynamic> json) => GoalScoreModel(
        math: (json['math'] as num?)?.toInt() ?? 0,
        english: (json['english'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {'math': math, 'english': english};
}

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.login,
    super.email,
    super.phone,
    super.image,
    super.tillExam,
    super.goalScore,
    super.goalUniversity,
    super.hasPassword,
    super.state,
    super.studentBalance,
    super.paidUntil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['_id'] ?? json['id'] ?? '') as String,
        name: json['name'] as String? ?? '',
        login: json['login'] as String? ?? '',
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        image: json['image'] as String?,
        tillExam: json['tillExam'] is String
            ? DateTime.tryParse(json['tillExam'] as String)
            : null,
        goalScore: json['goalScore'] is Map<String, dynamic>
            ? GoalScoreModel.fromJson(json['goalScore'] as Map<String, dynamic>)
            : null,
        goalUniversity: json['goalUniversity'] as String?,
        hasPassword: json['hasPassword'] as bool? ?? false,
        state: json['state'] as String? ?? '',
        studentBalance: (json['studentBalance'] as num?) ?? 0,
        paidUntil: json['paidUntil'] is String
            ? DateTime.tryParse(json['paidUntil'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'login': login,
        'email': email,
        'phone': phone,
        'image': image,
        'tillExam': tillExam?.toIso8601String(),
        'goalScore': goalScore == null
            ? null
            : {'math': goalScore!.math, 'english': goalScore!.english},
        'goalUniversity': goalUniversity,
        'hasPassword': hasPassword,
        'state': state,
        'studentBalance': studentBalance,
        'paidUntil': paidUntil?.toIso8601String(),
      };
}
