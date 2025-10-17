import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/home/domain/entities/routine.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../repositories/home_repositories.dart';

class UpdateRoutine implements UseCase<int, Routine> {
  HomeRepository routineRepository;

  UpdateRoutine(this.routineRepository);

  @override
  Future<Either<Failure, int>?> call(Routine routine) async {
    return await routineRepository.updateRoutine(routine);
  }
}
