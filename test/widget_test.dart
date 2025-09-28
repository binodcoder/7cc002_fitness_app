// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/injection_container.dart' as di;
import 'package:fitness_app/features/auth/application/auth/auth_bloc.dart';
import 'package:fitness_app/features/auth/domain/usecases/logout.dart';
import 'package:fitness_app/features/auth/application/login/login_bloc.dart';
import 'package:fitness_app/features/auth/domain/usecases/login.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:fitness_app/features/auth/domain/entities/login_credentials.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart'
    as user_entity;
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/app/app.dart';
import 'package:fitness_app/core/widgets/splash_screen.dart';
import 'package:fitness_app/features/auth/presentation/login/ui/login_screen.dart';

class _FakeSessionManager implements SessionManager {
  bool seenOnboarding = false;
  @override
  Future<void> clear({bool preserveOnboarding = true}) async {}
  @override
  user_entity.User? getCurrentUser() => null;
  @override
  bool hasSeenOnboarding() => seenOnboarding;
  @override
  Future<bool> isLoggedIn() async => false;
  @override
  Future<void> persistUser(user_entity.User user) async {}
  @override
  Future<void> setSeenOnboarding(bool value) async {
    seenOnboarding = value;
  }
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, int>>? logout() async => const Right(1);
  @override
  Future<Either<Failure, user_entity.User>>? login(
          LoginCredentials loginCredentials) async =>
      Left(ServerFailure());
  @override
  Future<Either<Failure, int>>? addUser(user_entity.User user) async =>
      const Right(1);
  @override
  Future<Either<Failure, int>>? updateUser(user_entity.User user) async =>
      const Right(1);
  @override
  Future<Either<Failure, int>>? deleteUser(int userId) async => const Right(1);
}

void main() {
  testWidgets('MyApp builds and shows SplashScreen', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    // Minimal DI needed for SplashScreen and AuthBloc
    if (!di.sl.isRegistered<SharedPreferences>()) {
      di.sl.registerLazySingleton<SharedPreferences>(() => prefs);
    }

    final fakeSession = _FakeSessionManager();
    if (!di.sl.isRegistered<SessionManager>()) {
      di.sl.registerLazySingleton<SessionManager>(() => fakeSession);
    }
    if (!di.sl.isRegistered<Logout>()) {
      di.sl.registerLazySingleton<Logout>(() => Logout(_FakeAuthRepository()));
    }
    if (!di.sl.isRegistered<LoginBloc>()) {
      di.sl.registerFactory<LoginBloc>(
        () => LoginBloc(login: Login(_FakeAuthRepository())),
      );
    }
    if (!di.sl.isRegistered<AuthBloc>()) {
      di.sl.registerFactory<AuthBloc>(
          () => AuthBloc(logout: di.sl<Logout>(), sessionManager: fakeSession));
    }

    await tester.pumpWidget(const MyApp());
    await tester.pump();

    final splashFinder = find.byType(SplashScreen);
    final loginFinder = find.byType(LoginPage);
    expect(splashFinder.evaluate().isNotEmpty || loginFinder.evaluate().isNotEmpty,
        true);
  });
}
