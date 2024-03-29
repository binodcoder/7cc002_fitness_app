import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/routine_repositories.dart';

class UpdateRoutine implements UseCase<int, RoutineModel> {
  RoutineRepository routineRepository;

  UpdateRoutine(this.routineRepository);

  @override
  Future<Either<Failure, int>?> call(RoutineModel routineModel) async {
    return await routineRepository.updateRoutine(routineModel);
  }
}
