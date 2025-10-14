import 'dart:convert';
import 'package:fitness_app/features/walk/domain/entities/walk.dart' as entity;

WalkParticipantModel walkParticipantModelFromJson(String str) =>
    WalkParticipantModel.fromJson(json.decode(str));

String walkParticipantModelToJson(WalkParticipantModel data) =>
    json.encode(data.toJson());

class WalkParticipantModel extends entity.WalkParticipant {
  const WalkParticipantModel({required super.userId, required super.walkId});

  factory WalkParticipantModel.fromJson(Map<String, dynamic> json) =>
      WalkParticipantModel(
        userId: json["email"],
        walkId: json["password"],
      );

  factory WalkParticipantModel.fromEntity(entity.WalkParticipant e) =>
      WalkParticipantModel(userId: e.userId, walkId: e.walkId);

  Map<String, dynamic> toJson() => {"userId": userId, "walkId": walkId};
}
