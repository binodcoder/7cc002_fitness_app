import 'dart:convert';

ExerciseModel exerciseModelFromJson(String str) => ExerciseModel.fromJson(json.decode(str));

String exerciseModelToJson(ExerciseModel data) => json.encode(data.toJson());

List<ExerciseModel> routineModelsFromJson(String str) => List<ExerciseModel>.from(json.decode(str).map((x) => ExerciseModel.fromJson(x)));

String exerciseModelsToJson(List<ExerciseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExerciseModel {
  int id;
  String name;
  String description;
  String targetMuscleGroups;
  String difficulty;
  String equipment;
  String imageUrl;
  String? videoUrl;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.targetMuscleGroups,
    required this.difficulty,
    required this.equipment,
    required this.imageUrl,
    required this.videoUrl,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        targetMuscleGroups: json["targetMuscleGroups"],
        difficulty: json["difficulty"],
        equipment: json["equipment"],
        imageUrl: json["imageUrl"],
        videoUrl: json["videoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "targetMuscleGroups": targetMuscleGroups,
        "difficulty": difficulty,
        "equipment": equipment,
        "imageUrl": imageUrl,
        "videoUrl": videoUrl,
      };
}
