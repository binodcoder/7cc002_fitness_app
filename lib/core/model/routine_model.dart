import 'dart:convert';

import '../entities/routine.dart';

List<RoutineModel> routineModelFromJson(String str) => List<RoutineModel>.from(
      json.decode(str).map(
            (x) => RoutineModel.fromJson(x),
          ),
    );

String routineModelToJson(List<RoutineModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoutineModel extends Routine {
  RoutineModel({
    required int id,
    required int couchId,
    required String description,
    required String source,
  }) : super(
          id,
          couchId,
          description,
          source,
        );

  factory RoutineModel.fromJson(Map<dynamic, dynamic> json) {
    return RoutineModel(
      id: json['id'],
      couchId: json['coachId'],
      description: json['description'],
      source: json['source'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'couchId': coachId,
      'description': description,
      'source': source,
    };
  }
}
