import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/walk_model.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/walk_repositories.dart';

class GetWalks implements UseCase<List<WalkModel>, NoParams> {
  final WalkRepository repository;

  GetWalks(this.repository);

  @override
  Future<Either<Failure, List<WalkModel>>?> call(NoParams noParams) async {
    return await repository.getWalks();
  }
}
