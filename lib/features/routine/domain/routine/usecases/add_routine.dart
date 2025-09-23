import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/routine_model.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/routine_repositories.dart';

class AddRoutine implements UseCase<int, RoutineModel> {
  final RoutineRepository addRoutineRepository;

  AddRoutine(this.addRoutineRepository);

  @override
  Future<Either<Failure, int>?> call(RoutineModel routineModel) async {
    return await addRoutineRepository.addRoutine(routineModel);
  }
}
