import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/walk_repositories.dart';

class GetWalks implements UseCase<List<Walk>, NoParams> {
  final WalkRepository repository;

  GetWalks(this.repository);

  @override
  Future<Either<Failure, List<Walk>>?> call(NoParams noParams) async {
    return await repository.getWalks();
  }
}
