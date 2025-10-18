import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/auth/data/datasources/rest_auth_data_source.dart';
import 'package:fitness_app/features/auth/data/models/login_credentials_model.dart';
import 'package:fitness_app/core/models/user_model.dart';

void main() {
  group('AuthRemoteDataSource', () {
    test('login returns UserModel on 200', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        return http.Response(
          jsonEncode({
            'name': 'n',
            'email': 'e',
            'password': 'p',
            'age': 1,
            'gender': 'g',
            'institutionEmail': 'i',
            'role': 'r',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final ds = RestAuthDataSourceImpl(client: client);
      final res = await ds.login(const LoginCredentialsModel(email: 'e', password: 'p'));
      expect(res, isA<UserModel>());
      expect(res.email, 'e');
    });

    test('login throws LoginException on non-200', () async {
      final client = MockClient((request) async => http.Response('no', 401));
      final ds = RestAuthDataSourceImpl(client: client);
      expect(() => ds.login(const LoginCredentialsModel(email: 'e', password: 'p')),
          throwsA(isA<LoginException>()));
    });

    test('addUser returns 1 on 201', () async {
      final client = MockClient((request) async => http.Response('', 201));
      final ds = RestAuthDataSourceImpl(client: client);
      final res = await ds.addUser(const UserModel(
        name: 'n',
        email: 'e',
        password: 'p',
        age: 0,
        gender: 'g',
        institutionEmail: 'i',
        role: 'r',
      ));
      expect(res, 1);
    });

    test('addUser throws ServerException on non-201', () async {
      final client = MockClient((request) async => http.Response('', 400));
      final ds = RestAuthDataSourceImpl(client: client);
      expect(
        () => ds.addUser(const UserModel(
          name: 'n',
          email: 'e',
          password: 'p',
          age: 0,
          gender: 'g',
          institutionEmail: 'i',
          role: 'r',
        )),
        throwsA(isA<ServerException>()),
      );
    });

    test('updateUser returns 1 on 201', () async {
      final client = MockClient((request) async => http.Response('', 201));
      final ds = RestAuthDataSourceImpl(client: client);
      final res = await ds.updateUser(const UserModel(
        id: 1,
        name: 'n',
        email: 'e',
        password: 'p',
        age: 0,
        gender: 'g',
        institutionEmail: 'i',
        role: 'r',
      ));
      expect(res, 1);
    });

    test('deleteUser returns 1 on 201', () async {
      final client = MockClient((request) async => http.Response('', 201));
      final ds = RestAuthDataSourceImpl(client: client);
      final res = await ds.deleteUser(1);
      expect(res, 1);
    });
  });
}
