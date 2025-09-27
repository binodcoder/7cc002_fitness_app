import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/walk/data/data_sources/walks_remote_data_source.dart';
import 'package:fitness_app/features/walk/data/models/walk_model.dart';
import 'package:fitness_app/features/walk/data/models/walk_participant_model.dart';

void main() {
  group('WalkRemoteDataSource', () {
    test('getWalks returns list on 200', () async {
      final client = MockClient((_) async => http.Response(jsonEncode([
        {
          'id': 1,
          'proposerId': 2,
          'routeData': 'encoded-polyline',
          'date': '2025-01-01',
          'startTime': '09:00',
          'startLocation': 'Campus',
          'participants': []
        }
      ]), 200, headers: {'content-type':'application/json'}));
      final ds = WalkRemoteDataSourceImpl(client: client);
      final res = await ds.getWalks();
      expect(res, isA<List<WalkModel>>());
    });

    test('add/update/delete/join/leave return 1 on success codes', () async {
      final created = WalkRemoteDataSourceImpl(client: MockClient((_) async => http.Response('', 201)));
      final ok = WalkRemoteDataSourceImpl(client: MockClient((_) async => http.Response('', 200)));
      final walk = WalkModel(
        id: 1,
        proposerId: 2,
        routeData: 'enc',
        date: DateTime(2025, 1, 1),
        startTime: '09:00',
        startLocation: 'Campus',
      );
      expect(await created.addWalk(walk), 1);
      expect(await ok.updateWalk(walk), 1);
      expect(await created.deleteWalk(1), 1);
      expect(await ok.joinWalk(const WalkParticipantModel(userId: 1, walkId: 2)), 1);
      expect(await ok.leaveWalk(const WalkParticipantModel(userId: 1, walkId: 2)), 1);
    });

    test('throws on error', () async {
      final ds = WalkRemoteDataSourceImpl(client: MockClient((_) async => http.Response('', 500)));
      expect(() => ds.getWalks(), throwsA(isA<ServerException>()));
    });
  });
}
