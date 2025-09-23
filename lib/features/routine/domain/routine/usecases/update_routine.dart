import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/routine_model.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../repositories/routine_repositories.dart';

class UpdateRoutine implements UseCase<int, RoutineModel> {
  RoutineRepository routineRepository;

  UpdateRoutine(this.routineRepository);

  @override
  Future<Either<Failure, int>?> call(RoutineModel routineModel) async {
    return await routineRepository.updateRoutine(routineModel);
  }
}
