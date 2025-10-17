import 'package:fitness_app/features/home/domain/entities/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseItemData {
  final String key = UniqueKey().toString();
  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController targetMuscleGroups = TextEditingController();
  final TextEditingController difficulty = TextEditingController();
  final TextEditingController equipment = TextEditingController();
  final TextEditingController imageUrl = TextEditingController();
  final TextEditingController videoUrl = TextEditingController();
  int? id;

  ExerciseItemData();

  factory ExerciseItemData.fromEntity(Exercise ex) {
    final d = ExerciseItemData();
    d.id = ex.id;
    d.name.text = ex.name;
    d.description.text = ex.description;
    d.targetMuscleGroups.text = ex.targetMuscleGroups;
    d.difficulty.text = ex.difficulty.name;
    d.equipment.text = ex.equipment;
    d.imageUrl.text = ex.imageUrl;
    d.videoUrl.text = ex.videoUrl ?? '';
    return d;
  }

  Exercise toEntity() {
    final generatedId = id ?? DateTime.now().millisecondsSinceEpoch;
    return Exercise(
      id: generatedId,
      name: name.text.trim(),
      description: description.text.trim(),
      targetMuscleGroups: targetMuscleGroups.text.trim(),
      difficulty: ExerciseDifficultyX.fromString(difficulty.text.trim()),
      equipment: equipment.text.trim(),
      imageUrl: imageUrl.text.trim(),
      videoUrl: videoUrl.text.trim().isEmpty ? null : videoUrl.text.trim(),
    );
  }
}
