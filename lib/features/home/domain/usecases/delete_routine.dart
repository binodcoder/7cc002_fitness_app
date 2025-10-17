import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../repositories/home_repositories.dart';

class DeleteRoutine implements UseCase<int, int> {
  HomeRepository routineRepository;

  DeleteRoutine(this.routineRepository);

  @override
  Future<Either<Failure, int>?> call(int routineId) async {
    return await routineRepository.deleteRoutine(routineId);
  }
}
