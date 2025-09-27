import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/appointment/data/datasources/sync_remote_data_source.dart';
import 'package:fitness_app/features/appointment/data/models/sync_data_model.dart';

void main() {
  group('SyncRemoteDataSource', () {
    test('sync returns SyncModel on 200', () async {
      final client = MockClient((_) async => http.Response(jsonEncode({
        'userEmail': 'e',
        'appointments': [],
      }), 200, headers: {'content-type': 'application/json'}));
      final ds = SyncRemoteDataSourceImpl(client: client);
      final res = await ds.sync('e');
      expect(res, isA<SyncModel>());
    });

    test('sync throws on error', () async {
      final ds = SyncRemoteDataSourceImpl(client: MockClient((_) async => http.Response('', 500)));
      expect(() => ds.sync('e'), throwsA(isA<ServerException>()));
    });
  });
}

