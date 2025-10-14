import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile?>> getCurrentProfile();
  Future<Either<Failure, int>> upsertProfile(UserProfile profile);
}
