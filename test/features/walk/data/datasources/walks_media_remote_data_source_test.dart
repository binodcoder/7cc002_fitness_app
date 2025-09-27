import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/walk/data/data_sources/walks_media_remote_data_source.dart';
import 'package:fitness_app/features/walk/data/models/walk_media_model.dart';

void main() {
  group('WalkMediaRemoteDataSource', () {
    test('getWalkMedias returns list on 200', () async {
      final ds = WalkMediaRemoteDataSourceImpl(client: MockClient((_) async => http.Response(jsonEncode([
        {'id':1,'walkId':2,'userId':3,'mediaUrl':'u'}
      ]), 200, headers: {'content-type':'application/json'})));
      final res = await ds.getWalkMedias();
      expect(res, isA<List<WalkMediaModel>>());
    });
    test('getWalkMediaByWalkId returns [] on 404', () async {
      final ds = WalkMediaRemoteDataSourceImpl(client: MockClient((_) async => http.Response('', 404)));
      final res = await ds.getWalkMediaByWalkId(2);
      expect(res, isEmpty);
    });
    test('add/update/delete status codes', () async {
      final created = WalkMediaRemoteDataSourceImpl(client: MockClient((_) async => http.Response('', 201)));
      final ok = WalkMediaRemoteDataSourceImpl(client: MockClient((_) async => http.Response('', 200)));
      const model = WalkMediaModel(id: 1, walkId: 2, userId: 3, mediaUrl: 'u');
      expect(await created.addWalkMedia(model), 1);
      expect(await ok.updateWalkMedia(model), 1);
      expect(await ok.deleteWalkMedia(1), 1);
    });
    test('throws on error', () async {
      final ds = WalkMediaRemoteDataSourceImpl(client: MockClient((_) async => http.Response('', 500)));
      expect(() => ds.getWalkMedias(), throwsA(isA<ServerException>()));
    });
  });
}
