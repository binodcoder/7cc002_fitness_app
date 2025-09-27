import 'package:fitness_app/features/auth/data/models/login_credentials_model.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:fitness_app/features/auth/domain/usecases/login.dart';
import 'package:fitness_app/features/auth/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late Login usecase;
  late MockAuthRepository mockAuthRepository;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = Login(mockAuthRepository);
  });

  UserModel tUser = const UserModel(
    email: "",
    name: " ",
    password: " ",
    age: 0,
    gender: '',
    institutionEmail: '',
    role: '',
  );
  LoginCredentialsModel tLoginModel =
      const LoginCredentialsModel(email: "", password: "");
  test(
    'should get user from the repository',
    () async {
      when(mockAuthRepository.login(tLoginModel))
          .thenAnswer((_) async => Right(tUser));
      final result = await usecase(tLoginModel);
      expect(result, Right(tUser));
      verify(mockAuthRepository.login(tLoginModel));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
