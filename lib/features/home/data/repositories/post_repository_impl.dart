import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';
import '../../domain/repositories/routine_repositories.dart';
import '../data_sources/routines_local_data_sources.dart';

class PostRepositoryImpl implements RoutineRepository {
  final RoutinesLocalDataSource postLocalDataSource;

  PostRepositoryImpl({
    required this.postLocalDataSource,
  });

  @override
  Future<Either<Failure, List<RoutineModel>>> getRoutines() async {
    try {
      List<RoutineModel> postModelList = await postLocalDataSource.getRoutines();
      return Right(postModelList);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
