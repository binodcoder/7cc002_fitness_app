import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/routine_repositories.dart';

class DeleteRoutine implements UseCase<int, int> {
  RoutineRepository routineRepository;

  DeleteRoutine(this.routineRepository);

  @override
  Future<Either<Failure, int>?> call(int routineId) async {
    return await routineRepository.deleteRoutine(routineId);
  }
}
