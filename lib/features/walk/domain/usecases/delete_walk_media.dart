import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/walk_media_repositories.dart';

class DeleteWalkMedia implements UseCase<int, int> {
  final WalkMediaRepository walkMediaRepository;

  DeleteWalkMedia(this.walkMediaRepository);

  @override
  Future<Either<Failure, int>?> call(int id) async {
    return await walkMediaRepository.deleteWalkMedia(id);
  }
}
