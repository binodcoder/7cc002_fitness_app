import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/sync_repositories.dart';

class Sync implements UseCase<SyncEntity, String> {
  final SyncRepository syncRepository;

  Sync(this.syncRepository);

  @override
  Future<Either<Failure, SyncEntity>?> call(String email) async {
    return await syncRepository.sync(email);
  }
}
