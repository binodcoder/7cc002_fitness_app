import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/features/auth/domain/entities/login_credentials.dart';
import 'package:fitness_app/core/entities/user.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:fitness_app/features/auth/domain/usecases/login.dart';
import 'package:fitness_app/features/auth/application/login/login_bloc.dart';
import 'package:fitness_app/features/auth/application/login/login_event.dart';
import 'package:fitness_app/features/auth/application/login/login_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubAuthRepository implements AuthRepository {
  Either<Failure, User>? loginResult;
  Either<Failure, int>? resetPasswordResult;

  @override
  Future<Either<Failure, User>>? login(LoginCredentials loginCredentials) {
    return loginResult == null ? null : Future.value(loginResult);
  }

  @override
  Future<Either<Failure, int>>? logout() {
    throw UnimplementedError();
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

void main() {
  late _StubAuthRepository repository;
  late LoginBloc bloc;

  const credentials =
      LoginCredentials(email: 'user@test.com', password: '123456');
  const user = User(
    id: 42,
    age: 30,
    email: 'user@test.com',
    gender: 'female',
    institutionEmail: 'inst@test.com',
    name: 'Tester',
    password: '123456',
    role: 'standard',
  );

  setUp(() {
    repository = _StubAuthRepository();
    bloc = LoginBloc(login: Login(repository));
  });

  tearDown(() async {
    await bloc.close();
  });

  test('emits loading then success when login succeeds', () async {
    repository.loginResult = const Right(user);

    bloc.add(const LoginButtonPressEvent(login: credentials));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<LoginState>((state) => state.status == LoginStatus.loading),
        predicate<LoginState>(
          (state) => state.status == LoginStatus.success && state.user == user,
        ),
      ]),
    );
  });

  test('emits loading then failure when login fails', () async {
    repository.loginResult = Left(ServerFailure());

    bloc.add(const LoginButtonPressEvent(login: credentials));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<LoginState>((state) => state.status == LoginStatus.loading),
        predicate<LoginState>(
          (state) =>
              state.status == LoginStatus.failure &&
              state.errorMessage == AppStringsEn.serverFailure,
        ),
      ]),
    );
  });
}
