import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';

abstract class UpdatePostRepository {
  Future<Either<Failure, int>>? updatePost(RoutineModel post);
}
