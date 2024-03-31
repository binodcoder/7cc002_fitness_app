import 'dart:convert';

List<RoutineModel> routineModelsFromJson(String str) => List<RoutineModel>.from(json.decode(str).map((x) => RoutineModel.fromJson(x)));

String routineModelsToJson(List<RoutineModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
RoutineModel routineModelFromJson(String str) => RoutineModel.fromJson(json.decode(str));

String routineModelToJson(RoutineModel data) => json.encode(data.toJson());

class RoutineModel {
  int? id;
  String name;
  String description;
  String difficulty;
  int duration;
  String source;

  RoutineModel({
    this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.duration,
    required this.source,
  });

  factory RoutineModel.fromJson(Map<String, dynamic> json) => RoutineModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        difficulty: json["difficulty"],
        duration: json["duration"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "difficulty": difficulty,
        "duration": duration,
        "source": source,
      };
}
