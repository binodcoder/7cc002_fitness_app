import 'package:fitness_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class StreamMessages
    implements UseCase<Stream<Either<Failure, List<ChatMessage>>>, String> {
  final ChatRepository repository;
  StreamMessages(this.repository);

  @override
  Future<Either<Failure, Stream<Either<Failure, List<ChatMessage>>>>?> call(
      String roomId) async {
    // Wrap stream into Right to satisfy UseCase signature.
    return Right(repository.streamMessages(roomId));
  }
}
