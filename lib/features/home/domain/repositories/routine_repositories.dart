import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';

abstract class RoutineRepository {
  Future<Either<Failure, List<RoutineModel>>>? getRoutines();
}
