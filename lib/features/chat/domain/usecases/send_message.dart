import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendMessage implements UseCase<int, ChatMessage> {
  final ChatRepository repository;
  SendMessage(this.repository);

  @override
  Future<Either<Failure, int>?> call(ChatMessage message) async {
    return repository.sendMessage(message);
  }
}
