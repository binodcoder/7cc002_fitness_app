import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart';

abstract class SyncRepository {
  Future<Either<Failure, SyncEntity>>? sync(String email);
}
