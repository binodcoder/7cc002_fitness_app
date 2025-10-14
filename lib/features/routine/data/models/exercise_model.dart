import 'dart:convert';
import 'package:fitness_app/features/routine/domain/entities/exercise.dart';

ExerciseModel exerciseModelFromJson(String str) =>
    ExerciseModel.fromJson(json.decode(str));

String exerciseModelToJson(ExerciseModel data) => json.encode(data.toJson());

List<ExerciseModel> exerciseModelsFromJson(String str) =>
    List<ExerciseModel>.from(
        json.decode(str).map((x) => ExerciseModel.fromJson(x)));

String exerciseModelsToJson(List<ExerciseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExerciseModel extends Exercise {
  const ExerciseModel({
    required super.id,
    required super.name,
    required super.description,
    required super.targetMuscleGroups,
    required super.difficulty,
    required super.equipment,
    required super.imageUrl,
    super.videoUrl,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        targetMuscleGroups: json["targetMuscleGroups"],
        difficulty: ExerciseDifficultyX.fromString(json["difficulty"]),
        equipment: json["equipment"],
        imageUrl: json["imageUrl"],
        videoUrl: json["videoUrl"],
      );

  factory ExerciseModel.fromEntity(Exercise e) => ExerciseModel(
        id: e.id,
        name: e.name,
        description: e.description,
        targetMuscleGroups: e.targetMuscleGroups,
        difficulty: e.difficulty,
        equipment: e.equipment,
        imageUrl: e.imageUrl,
        videoUrl: e.videoUrl,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "targetMuscleGroups": targetMuscleGroups,
        "difficulty": difficulty.name,
        "equipment": equipment,
        "imageUrl": imageUrl,
        "videoUrl": videoUrl,
      };
}
