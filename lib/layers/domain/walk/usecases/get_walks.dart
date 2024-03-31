import '../../../../core/errors/failures.dart';
import '../../../../core/model/walk_model.dart';
import '../../../../core/usecases/usecase.dart';
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
