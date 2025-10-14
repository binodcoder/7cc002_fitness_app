import 'dart:convert';
import 'package:fitness_app/features/profile/domain/entities/user_profile.dart'
    as entity;

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel extends entity.UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    required super.age,
    required super.gender,
    required super.height,
    required super.weight,
    required super.goal,
    required super.photoUrl,
    required super.lastUpdated,
  });

  factory UserProfileModel.fromEntity(entity.UserProfile e) => UserProfileModel(
        id: e.id,
        name: e.name,
        age: e.age,
        gender: e.gender,
        height: e.height,
        weight: e.weight,
        goal: e.goal,
        photoUrl: e.photoUrl,
        lastUpdated: e.lastUpdated,
      );

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json['id'] as String,
        name: (json['name'] as String?) ?? '',
        age: (json['age'] as num?)?.toInt() ?? 0,
        gender: (json['gender'] as String?) ?? '',
        height: (json['height'] as num?)?.toDouble() ?? 0,
        weight: (json['weight'] as num?)?.toDouble() ?? 0,
        goal: (json['goal'] as String?) ?? '',
        photoUrl: (json['photoUrl'] as String?) ?? '',
        lastUpdated:
            DateTime.tryParse((json['lastUpdated'] ?? '').toString()) ??
                DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'height': height,
        'weight': weight,
        'goal': goal,
        'photoUrl': photoUrl,
        'lastUpdated': lastUpdated.toIso8601String(),
      };
}
