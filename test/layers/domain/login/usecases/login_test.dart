import 'package:fitness_app/features/login/data/models/login_model.dart';
import 'package:fitness_app/features/login/domain/repositories/login_repositories.dart';
import 'package:fitness_app/features/login/domain/usecases/login.dart';
import 'package:fitness_app/features/register/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late Login usecase;
  late MockLoginRepository mockLoginRepository;
  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = Login(mockLoginRepository);
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
  LoginModel tLoginModel = const LoginModel(email: "", password: "");
  test(
    'should get user from the repository',
    () async {
      when(mockLoginRepository.login(tLoginModel))
          .thenAnswer((_) async => Right(tUser));
      final result = await usecase(tLoginModel);
      expect(result, Right(tUser));
      verify(mockLoginRepository.login(tLoginModel));
      verifyNoMoreInteractions(mockLoginRepository);
    },
  );
}
