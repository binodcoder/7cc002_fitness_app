import 'dart:convert';
import 'package:fitness_app/features/home/domain/entities/routine.dart';
import 'exercise_model.dart';

RoutineModel routineModelFromJson(String str) =>
    RoutineModel.fromJson(json.decode(str));

String routineModelToJson(RoutineModel data) => json.encode(data.toJson());

List<RoutineModel> routineModelsFromJson(String str) => List<RoutineModel>.from(
    json.decode(str).map((x) => RoutineModel.fromJson(x)));

String routineModelsToJson(List<RoutineModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoutineModel extends Routine {
  const RoutineModel({
    super.id,
    required super.name,
    required super.description,
    required super.duration,
    required super.source,
    List<ExerciseModel> exercises = const [],
  }) : super(exercises: exercises);

  factory RoutineModel.fromJson(Map<String, dynamic> json) => RoutineModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        // Accept numeric duration as int or double in payloads
        duration: (json["duration"] as num).toInt(),
        source: json["source"],
        exercises: json["exercises"] != null
            ? List<ExerciseModel>.from(
                json["exercises"].map((x) => ExerciseModel.fromJson(x)))
            : const [],
      );

  factory RoutineModel.fromEntity(Routine e) => RoutineModel(
        id: e.id,
        name: e.name,
        description: e.description,
        duration: e.duration,
        source: e.source,
        exercises: e.exercises
            .map(
                (ex) => ex is ExerciseModel ? ex : ExerciseModel.fromEntity(ex))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "duration": duration,
        "source": source,
        "exercises":
            exercises.map((x) => (x as ExerciseModel).toJson()).toList(),
      };
}
