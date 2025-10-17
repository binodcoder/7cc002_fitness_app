import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/home/domain/entities/routine.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/home_repositories.dart';

class AddRoutine implements UseCase<int, Routine> {
  final HomeRepository addRoutineRepository;

  AddRoutine(this.addRoutineRepository);

  @override
  Future<Either<Failure, int>?> call(Routine routine) async {
    return await addRoutineRepository.addRoutine(routine);
  }
}
