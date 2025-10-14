import 'package:fitness_app/features/auth/domain/entities/user.dart';
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManagerImpl implements SessionManager {
  final SharedPreferences _preferences;

  SessionManagerImpl(this._preferences);

  static const String _loginKey = 'login';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userRoleKey = 'role';
  static const String _userPasswordKey = 'user_password';
  static const String _onboardingKey = 'seen_onboarding';

  @override
  Future<void> persistUser(User user) async {
    await _preferences.setBool(_loginKey, true);
    if (user.id != null) {
      await _preferences.setInt(_userIdKey, user.id!);
    } else {
      await _preferences.remove(_userIdKey);
    }
    await _preferences.setString(_userEmailKey, user.email);
    await _preferences.setString(_userRoleKey, user.role);
    await _preferences.setString(_userPasswordKey, user.password);
  }

  @override
  User? getCurrentUser() {
    final loggedIn = _preferences.getBool(_loginKey) ?? false;
    if (!loggedIn) return null;

    final email = _preferences.getString(_userEmailKey);
    final role = _preferences.getString(_userRoleKey);
    final password = _preferences.getString(_userPasswordKey) ?? '';
    if (email == null || role == null) {
      return null;
    }
    return User(
      id: _preferences.getInt(_userIdKey),
      email: email,
      password: password,
      role: role,
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    return _preferences.getBool(_loginKey) ?? false;
  }

  @override
  Future<void> clear({bool preserveOnboarding = true}) async {
    final seen = hasSeenOnboarding() && preserveOnboarding;
    await _preferences.clear();
    if (seen) {
      await _preferences.setBool(_onboardingKey, true);
    }
  }

  @override
  bool hasSeenOnboarding() {
    return _preferences.getBool(_onboardingKey) ?? false;
  }

  @override
  Future<void> setSeenOnboarding(bool value) async {
    await _preferences.setBool(_onboardingKey, value);
  }
}
