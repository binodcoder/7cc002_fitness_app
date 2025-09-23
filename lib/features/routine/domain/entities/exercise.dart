import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final int id;
  final String name;
  final String description;
  final String targetMuscleGroups;
  final String difficulty;
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
  List<Object?> get props => [id, name, description, targetMuscleGroups, difficulty, equipment, imageUrl, videoUrl];
}

