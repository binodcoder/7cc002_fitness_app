import 'package:equatable/equatable.dart';

class WalkMedia extends Equatable {
  final int? id;
  final int walkId;
  final int userId;
  final String mediaUrl;

  const WalkMedia({this.id, required this.walkId, required this.userId, required this.mediaUrl});

  @override
  List<Object?> get props => [id, walkId, userId, mediaUrl];
}

