import 'package:equatable/equatable.dart';

enum ExerciseDifficulty { easy, medium, hard, unknown }

extension ExerciseDifficultyX on ExerciseDifficulty {
  static ExerciseDifficulty fromString(String? value) {
    final v = (value ?? '').trim().toLowerCase();
    switch (v) {
      case 'easy':
        return ExerciseDifficulty.easy;
      case 'medium':
        return ExerciseDifficulty.medium;
      case 'hard':
        return ExerciseDifficulty.hard;
      default:
        return ExerciseDifficulty.unknown;
    }
  }

  String get label {
    switch (this) {
      case ExerciseDifficulty.easy:
        return 'Easy';
      case ExerciseDifficulty.medium:
        return 'Medium';
      case ExerciseDifficulty.hard:
        return 'Hard';
      case ExerciseDifficulty.unknown:
        return 'Unknown';
    }
  }
}

class Exercise extends Equatable {
  final int id;
  final String name;
  final String description;
  final String targetMuscleGroups;
  final ExerciseDifficulty difficulty;
  final String equipment;
  final String imageUrl;
  final String? videoUrl;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.targetMuscleGroups,
    required this.difficulty,
    required this.equipment,
    required this.imageUrl,
    this.videoUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        targetMuscleGroups,
        difficulty,
        equipment,
        imageUrl,
        videoUrl
      ];
}
