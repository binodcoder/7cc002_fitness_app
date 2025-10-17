import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/services/session_manager.dart';
import 'package:fitness_app/features/auth/domain/entities/login_credentials.dart';
import 'package:fitness_app/core/entities/user.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:fitness_app/features/auth/domain/usecases/logout.dart';
import 'package:fitness_app/features/auth/application/auth/auth_bloc.dart';
import 'package:fitness_app/features/auth/application/auth/auth_event.dart';
import 'package:fitness_app/features/auth/application/auth/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubAuthRepository implements AuthRepository {
  Either<Failure, User>? loginResult;
  Either<Failure, int>? logoutResult;
  Either<Failure, int>? resetPasswordResult;

  @override
  Future<Either<Failure, User>>? login(LoginCredentials loginCredentials) {
    return loginResult == null ? null : Future.value(loginResult);
  }

  @override
  Future<Either<Failure, int>>? logout() {
    return logoutResult == null ? null : Future.value(logoutResult);
  }

  @override
  Future<Either<Failure, int>>? addUser(User user) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>>? updateUser(User user) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>>? deleteUser(int userId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>>? resetPassword(String email) {
    return resetPasswordResult == null
        ? Future.value(const Right(1))
        : Future.value(resetPasswordResult);
  }
}

class _FakeSessionManager implements SessionManager {
  User? cachedUser;
  bool clearCalled = false;
  bool clearedWithPreserve = true;
  bool seenOnboarding = false;

  @override
  Future<void> clear({bool preserveOnboarding = true}) async {
    cachedUser = null;
    clearCalled = true;
    clearedWithPreserve = preserveOnboarding;
  }

  @override
  User? getCurrentUser() => cachedUser;

  @override
  bool hasSeenOnboarding() => seenOnboarding;

  @override
  Future<bool> isLoggedIn() async => cachedUser != null;

  @override
  Future<void> persistUser(User user) async {
    cachedUser = user;
  }

  @override
  Future<void> setSeenOnboarding(bool value) async {
    seenOnboarding = value;
  }
}

void main() {
  late _StubAuthRepository repository;
  late _FakeSessionManager sessionManager;
  late AuthBloc bloc;

  const user = User(
    id: 1,
    age: 28,
    email: 'user@test.com',
    gender: 'male',
    institutionEmail: 'inst@test.com',
    name: 'Test User',
    password: 'secret',
    role: 'trainer',
  );

  setUp(() {
    repository = _StubAuthRepository();
    sessionManager = _FakeSessionManager();
    bloc = AuthBloc(logout: Logout(repository), sessionManager: sessionManager);
  });

  tearDown(() async {
    await bloc.close();
  });

  test('emits authenticated when session reports cached user', () async {
    sessionManager.cachedUser = user;

    bloc.add(const AuthStatusRequested());

    await expectLater(
      bloc.stream,
      emits(
        predicate<AuthState>(
          (state) =>
              state.status == AuthStatus.authenticated && state.user == user,
        ),
      ),
    );
  });

  test('emits unauthenticated when logout succeeds', () async {
    sessionManager.cachedUser = user;
    repository.logoutResult = const Right(1);

    bloc
      ..add(const AuthStatusRequested())
      ..add(const AuthLoggedIn(user))
      ..add(const AuthLogoutRequested());

    await expectLater(
      bloc.stream,
      emitsThrough(
        predicate<AuthState>(
          (state) =>
              state.status == AuthStatus.unauthenticated && !state.isLoading,
        ),
      ),
    );

    expect(sessionManager.clearCalled, isTrue);
    expect(sessionManager.clearedWithPreserve, isTrue);
  });

  test('emits failure message when logout fails', () async {
    sessionManager.cachedUser = user;
    repository.logoutResult = Left(ServerFailure());

    bloc
      ..add(const AuthStatusRequested())
      ..add(const AuthLoggedIn(user))
      ..add(const AuthLogoutRequested());

    await expectLater(
      bloc.stream,
      emitsThrough(
        predicate<AuthState>(
          (state) =>
              state.status == AuthStatus.authenticated &&
              state.errorMessage != null &&
              state.isLoading == false,
        ),
      ),
    );

    expect(sessionManager.clearCalled, isFalse);
  });
}
