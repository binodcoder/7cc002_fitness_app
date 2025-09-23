import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/routine_repositories.dart';

class GetRoutines implements UseCase<List<Routine>, NoParams> {
  final RoutineRepository repository;

  GetRoutines(this.repository);

  @override
  Future<Either<Failure, List<Routine>>?> call(NoParams noParams) async {
    return await repository.getRoutines();
  }
}
