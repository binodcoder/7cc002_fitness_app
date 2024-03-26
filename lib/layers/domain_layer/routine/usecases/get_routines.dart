import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/routine_repositories.dart';

class GetRoutines implements UseCase<List<RoutineModel>, NoParams> {
  final RoutineRepository repository;

  GetRoutines(this.repository);

  @override
  Future<Either<Failure, List<RoutineModel>>?> call(NoParams noParams) async {
    return await repository.getRoutines();
  }
}
