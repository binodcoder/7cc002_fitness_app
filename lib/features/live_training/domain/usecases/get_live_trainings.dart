import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';
import '../repositories/live_training_repositories.dart';

class GetLiveTrainings implements UseCase<List<LiveTraining>, NoParams> {
  final LiveTrainingRepository repository;

  GetLiveTrainings(this.repository);

  @override
  Future<Either<Failure, List<LiveTraining>>?> call(NoParams noParams) async {
    return await repository.getLiveTrainings();
  }
}
