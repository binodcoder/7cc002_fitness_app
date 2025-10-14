import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/profile/domain/entities/user_profile.dart';
import 'package:fitness_app/features/profile/domain/repositories/profile_repository.dart';

class UpsertProfile {
  final ProfileRepository repository;
  UpsertProfile(this.repository);

  Future<Either<Failure, int>> call(UserProfile profile) =>
      repository.upsertProfile(profile);
}
