import 'package:fitness_app/core/entities/exercise.dart';

class ExerciseModel extends Exercise {
  ExerciseModel(
    String id,
    String name,
    String description,
    String targetMuscleGroups,
    String difficulty,
    List<String> equipment,
    String imageUrl,
    String videoUrl,
  ) : super(
          id,
          name,
          description,
          targetMuscleGroups,
          difficulty,
          equipment,
          imageUrl,
          videoUrl,
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': name,
      'content': description,
      'imagePath': targetMuscleGroups,
      'isSelected': difficulty,
      'equipment': equipment,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    };
  }
}
