import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/services/profile_guard_service.dart';
import 'package:fitness_app/features/profile/domain/entities/user_profile.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile.dart';
import 'package:fitness_app/core/errors/failures.dart';

class ProfileGuardServiceImpl implements ProfileGuardService {
  final GetProfile _getProfile;
  ProfileGuardServiceImpl(this._getProfile);

  @override
  Future<bool> isComplete() async {
    final Either<Failure, UserProfile?> res = await _getProfile();
    return res.fold((_) => false, (p) {
      if (p == null) return false;
      final hasBasics =
          p.name.trim().isNotEmpty && p.gender.trim().isNotEmpty && p.age > 0;
      final hasBody = p.height > 0 && p.weight > 0;
      return hasBasics && hasBody;
    });
  }
}
