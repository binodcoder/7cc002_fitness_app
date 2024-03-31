import 'dart:convert';

WalkParticipantModel walkParticipantModelFromJson(String str) => WalkParticipantModel.fromJson(json.decode(str));

String walkParticipantModelToJson(WalkParticipantModel data) => json.encode(data.toJson());

class WalkParticipantModel {
  int userId;
  int walkId;

  WalkParticipantModel({
    required this.userId,
    required this.walkId,
  });

  factory WalkParticipantModel.fromJson(Map<String, dynamic> json) => WalkParticipantModel(
        userId: json["email"],
        walkId: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "walkId": walkId,
      };
}
