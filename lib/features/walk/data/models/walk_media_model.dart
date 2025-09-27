// To parse this JSON data, do
//
//     final walkMediaModel = walkMediaModelFromJson(jsonString);

import 'dart:convert';
import 'package:fitness_app/features/walk/domain/entities/walk_media.dart' as entity;

List<WalkMediaModel> walkMediaModelsFromJson(String str) => List<WalkMediaModel>.from(json.decode(str).map((x) => WalkMediaModel.fromJson(x)));

String walkMediaModelsToJson(List<WalkMediaModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

WalkMediaModel walkMediaModelFromJson(String str) => WalkMediaModel.fromJson(json.decode(str));

String walkMediaModelToJson(WalkMediaModel data) => json.encode(data.toJson());

class WalkMediaModel extends entity.WalkMedia {
  const WalkMediaModel({super.id, required super.walkId, required super.userId, required super.mediaUrl});

  factory WalkMediaModel.fromJson(Map<String, dynamic> json) => WalkMediaModel(
        id: json["id"],
        walkId: json["walkId"],
        userId: json["userId"],
        mediaUrl: json["mediaUrl"],
      );

  factory WalkMediaModel.fromEntity(entity.WalkMedia e) => WalkMediaModel(id: e.id, walkId: e.walkId, userId: e.userId, mediaUrl: e.mediaUrl);

  Map<String, dynamic> toJson() => {"id": id, "walkId": walkId, "userId": userId, "mediaUrl": mediaUrl};
}

