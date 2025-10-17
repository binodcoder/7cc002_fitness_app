import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/home/domain/entities/routine.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/home_repositories.dart';

class GetRoutines implements UseCase<List<Routine>, NoParams> {
  final HomeRepository repository;

  GetRoutines(this.repository);

  @override
  Future<Either<Failure, List<Routine>>?> call(NoParams noParams) async {
    return await repository.getRoutines();
  }
}
