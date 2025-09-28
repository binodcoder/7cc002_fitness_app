import 'package:fitness_app/features/auth/domain/entities/user.dart';

abstract class SessionManager {
  Future<void> persistUser(User user);
  User? getCurrentUser();
  Future<bool> isLoggedIn();
  Future<void> clear({bool preserveOnboarding = true});
  bool hasSeenOnboarding();
  Future<void> setSeenOnboarding(bool value);
}

