import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/config/backend_config.dart';
import 'package:fitness_app/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:fitness_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:fitness_app/features/profile/data/models/user_profile_model.dart';
import 'package:fitness_app/features/profile/domain/entities/user_profile.dart';
import 'package:fitness_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource local;
  final ProfileRemoteDataSource? remote;

  ProfileRepositoryImpl({required this.local, this.remote});

  @override
  Future<Either<Failure, UserProfile?>> getCurrentProfile() async {
    try {
      if (BackendConfig.isFirebase && remote != null) {
        final model = await remote!.getCurrent();
        if (model == null) {
          final id = await remote!.currentAccountId();
          if (id == null) return const Right(null);
          final empty = UserProfileModel.fromEntity(UserProfile.empty(id));
          await local.upsert(empty);
          return Right(empty);
        }
        await local.upsert(model);
        return Right(model);
      } else {
        // If not firebase, fall back to local-only using numeric id from prefs if available
        // Without a cross-platform account id, return null
        return const Right(null);
      }
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>> upsertProfile(UserProfile profile) async {
    try {
      var model = UserProfileModel.fromEntity(profile);
      if (BackendConfig.isFirebase && remote != null) {
        final id = await remote!.currentAccountId();
        if (id != null && id.isNotEmpty && model.id != id) {
          model = UserProfileModel.fromEntity(
            profile.copyWith(id: id, lastUpdated: DateTime.now()),
          );
        }
        await remote!.upsert(model);
      }
      final res = await local.upsert(model);
      return Right(res);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
