import 'dart:convert';

import 'exercise_model.dart';

// List<RoutineModel> routineModelsFromJson(String str) => List<RoutineModel>.from(json.decode(str).map((x) => RoutineModel.fromJson(x)));
// String routineModelsToJson(List<RoutineModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
RoutineModel routineModelFromJson(String str) => RoutineModel.fromJson(json.decode(str));

String routineModelToJson(RoutineModel data) => json.encode(data.toJson());

List<RoutineModel> routineModelsFromJson(String str) => List<RoutineModel>.from(json.decode(str).map((x) => RoutineModel.fromJson(x)));

String routineModelsToJson(List<RoutineModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoutineModel {
  int? id;
  String name;
  String description;
  String difficulty;
  int duration;
  String source;
  List<ExerciseModel>? exercises;

  RoutineModel({
    this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.duration,
    required this.source,
    this.exercises,
  });

  factory RoutineModel.fromJson(Map<String, dynamic> json) => RoutineModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        difficulty: json["difficulty"],
        duration: json["duration"],
        source: json["source"],
        exercises: List<ExerciseModel>.from(json["exercises"].map((x) => ExerciseModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "difficulty": difficulty,
        "duration": duration,
        "source": source,
        "exercises": exercises != null ? List<dynamic>.from(exercises!.map((x) => x.toJson())) : [],
      };
}
