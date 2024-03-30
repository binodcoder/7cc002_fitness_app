import '../../../../core/errors/failures.dart';
import '../../../../core/model/walk_media_model.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/walk_media_repositories.dart';

class UpdateWalkMedia implements UseCase<int, WalkMediaModel> {
  final WalkMediaRepository updateWalkMediaRepository;

  UpdateWalkMedia(this.updateWalkMediaRepository);

  @override
  Future<Either<Failure, int>?> call(WalkMediaModel walkMediaModel) async {
    return await updateWalkMediaRepository.updateWalkMedia(walkMediaModel);
  }
}
