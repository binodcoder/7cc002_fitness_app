// To parse this JSON data, do
//
//     final walkMediaModel = walkMediaModelFromJson(jsonString);

import 'dart:convert';

List<WalkMediaModel> walkMediaModelsFromJson(String str) => List<WalkMediaModel>.from(json.decode(str).map((x) => WalkMediaModel.fromJson(x)));

String walkMediaModelsToJson(List<WalkMediaModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

WalkMediaModel walkMediaModelFromJson(String str) => WalkMediaModel.fromJson(json.decode(str));

String walkMediaModelToJson(WalkMediaModel data) => json.encode(data.toJson());

class WalkMediaModel {
  int? id;
  int walkId;
  int userId;
  String mediaUrl;

  WalkMediaModel({
    this.id,
    required this.walkId,
    required this.userId,
    required this.mediaUrl,
  });

  factory WalkMediaModel.fromJson(Map<String, dynamic> json) => WalkMediaModel(
        id: json["id"],
        walkId: json["walkId"],
        userId: json["userId"],
        mediaUrl: json["mediaUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "walkId": walkId,
        "userId": userId,
        "mediaUrl": mediaUrl,
      };
}
