import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id; // Same as UserAccount.id (foreign key)
  final String name;
  final int age;
  final String gender;
  final double height; // cm
  final double weight; // kg
  final String goal; // e.g., Lose Weight
  final String photoUrl; // local path or remote URL
  final DateTime lastUpdated;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.goal,
    required this.photoUrl,
    required this.lastUpdated,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    double? height,
    double? weight,
    String? goal,
    String? photoUrl,
    DateTime? lastUpdated,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      goal: goal ?? this.goal,
      photoUrl: photoUrl ?? this.photoUrl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  static UserProfile empty(String id) => UserProfile(
        id: id,
        name: '',
        age: 0,
        gender: '',
        height: 0,
        weight: 0,
        goal: '',
        photoUrl: '',
        lastUpdated: DateTime.now(),
      );

  @override
  List<Object?> get props =>
      [id, name, age, gender, height, weight, goal, photoUrl, lastUpdated];
}
