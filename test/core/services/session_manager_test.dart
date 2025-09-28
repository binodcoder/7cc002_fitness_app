import 'package:fitness_app/features/auth/domain/services/session_manager.dart';
import 'package:fitness_app/features/auth/data/services/session_manager_impl.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;
  late SessionManager sessionManager;

  const user = User(
    id: 10,
    age: 26,
    email: 'persist@test.com',
    gender: 'other',
    institutionEmail: 'inst@test.com',
    name: 'Persisted User',
    password: 'pwd',
    role: 'trainer',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    sessionManager = SessionManagerImpl(prefs);
  });

  test('persistUser stores and retrieves user data', () async {
    await sessionManager.persistUser(user);

    final cached = sessionManager.getCurrentUser();

    expect(cached, isNotNull);
    expect(cached!.email, user.email);
    expect(await sessionManager.isLoggedIn(), isTrue);
  });

  test('clear removes user but keeps onboarding flag when requested', () async {
    await sessionManager.setSeenOnboarding(true);
    await sessionManager.persistUser(user);

    await sessionManager.clear();

    expect(sessionManager.getCurrentUser(), isNull);
    expect(sessionManager.hasSeenOnboarding(), isTrue);
    expect(await sessionManager.isLoggedIn(), isFalse);
  });
}
