import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../core/model/live_training_model.dart';
import '../repositories/live_training_repositories.dart';

class GetLiveTrainings implements UseCase<List<LiveTrainingModel>, NoParams> {
  final LiveTrainingRepository repository;

  GetLiveTrainings(this.repository);

  @override
  Future<Either<Failure, List<LiveTrainingModel>>?> call(NoParams noParams) async {
    return await repository.getLiveTrainings();
  }
}
