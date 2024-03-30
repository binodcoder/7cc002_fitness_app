import 'package:fitness_app/core/model/walk_media_model.dart';
import 'package:fitness_app/layers/domain_layer/walk_media/repositories/walk_media_repositories.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../walk/repositories/walk_repositories.dart';

class GetWalkMedia implements UseCase<List<WalkMediaModel>, NoParams> {
  final WalkMediaRepository walkMediaRepository;

  GetWalkMedia(this.walkMediaRepository);

  @override
  Future<Either<Failure, List<WalkMediaModel>>?> call(NoParams noParams) async {
    return await walkMediaRepository.getWalkMedia();
  }
}
