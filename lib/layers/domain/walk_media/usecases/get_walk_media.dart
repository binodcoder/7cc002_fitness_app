import 'package:fitness_app/core/model/walk_media_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/walk_media_repositories.dart';

class GetWalkMedia implements UseCase<List<WalkMediaModel>, NoParams> {
  final WalkMediaRepository walkMediaRepository;

  GetWalkMedia(this.walkMediaRepository);

  @override
  Future<Either<Failure, List<WalkMediaModel>>?> call(NoParams noParams) async {
    return await walkMediaRepository.getWalkMedia();
  }
}
