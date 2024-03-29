import 'package:fitness_app/core/model/user_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/sync_data_model.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/sync_repositories.dart';

class Sync implements UseCase<SyncModel, NoParams> {
  final SyncRepository syncRepository;

  Sync(this.syncRepository);

  @override
  Future<Either<Failure, SyncModel>?> call(NoParams noParams) async {
    return await syncRepository.sync();
  }
}
