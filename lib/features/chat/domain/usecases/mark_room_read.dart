import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class MarkRoomReadParams {
  final String roomId;
  final String userId;
  const MarkRoomReadParams({required this.roomId, required this.userId});
}

class MarkRoomRead implements UseCase<int, MarkRoomReadParams> {
  final ChatRepository repository;
  MarkRoomRead(this.repository);

  @override
  Future<Either<Failure, int>?> call(MarkRoomReadParams params) async {
    return repository.markRoomRead(
        roomId: params.roomId, userId: params.userId);
  }
}
