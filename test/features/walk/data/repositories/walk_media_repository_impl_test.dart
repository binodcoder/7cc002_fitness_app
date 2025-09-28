import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:fitness_app/features/walk/data/data_sources/walks_media_local_data_source.dart';
import 'package:fitness_app/features/walk/data/data_sources/walks_media_remote_data_source.dart';
import 'package:fitness_app/features/walk/data/models/walk_media_model.dart';
import 'package:fitness_app/features/walk/data/repositories/walk_media_repository_impl.dart';
import 'package:fitness_app/core/errors/exceptions.dart';

class FakeNet implements NetworkInfo {
  FakeNet(this.connected);
  bool connected;
  @override
  Future<bool> get isConnected async => connected;
}

class FakeLocal implements WalkMediaLocalDataSource {
  List<WalkMediaModel> items = const [];
  @override
  Future<List<WalkMediaModel>> getWalkMediaByWalkId(int walkId) async =>
      items.where((e) => e.walkId == walkId).toList();
  @override
  Future<List<WalkMediaModel>> getWalkMedias() async => items;
}

class FakeRemoteOk implements WalkMediaRemoteDataSource {
  @override
  Future<int> addWalkMedia(WalkMediaModel walkMediaModel) async => 1;
  @override
  Future<int> deleteWalkMedia(int userId) async => 1;
  @override
  Future<List<WalkMediaModel>> getWalkMediaByWalkId(int walkId) async =>
      const [];
  @override
  Future<List<WalkMediaModel>> getWalkMedias() async => const [];
  @override
  Future<int> updateWalkMedia(WalkMediaModel walkMediaModel) async => 1;
}

class FakeRemoteFail implements WalkMediaRemoteDataSource {
  @override
  Future<int> addWalkMedia(WalkMediaModel walkMediaModel) async =>
      throw ServerException();
  @override
  Future<int> deleteWalkMedia(int userId) async => throw ServerException();
  @override
  Future<List<WalkMediaModel>> getWalkMediaByWalkId(int walkId) async =>
      throw ServerException();
  @override
  Future<List<WalkMediaModel>> getWalkMedias() async => throw ServerException();
  @override
  Future<int> updateWalkMedia(WalkMediaModel walkMediaModel) async =>
      throw ServerException();
}

void main() {
  test('online returns Right', () async {
    final repo = WalkMediaRepositoryImpl(
        walkMediaLocalDataSource: FakeLocal(),
        walkMediaRemoteDataSource: FakeRemoteOk(),
        networkInfo: FakeNet(true));
    final res = await repo.getWalkMedia();
    expect(res, isNotNull);
    res.fold((l) => fail('Expected Right'), (r) => expect(r, []));
    expect(
        await repo.addWalkMedia(
            const WalkMediaModel(id: 1, walkId: 2, userId: 3, mediaUrl: 'u')),
        const Right(1));
  });
  test('offline returns local', () async {
    final local = FakeLocal()
      ..items = const [
        WalkMediaModel(id: 1, walkId: 2, userId: 3, mediaUrl: 'u')
      ];
    final repo = WalkMediaRepositoryImpl(
        walkMediaLocalDataSource: local,
        walkMediaRemoteDataSource: FakeRemoteOk(),
        networkInfo: FakeNet(false));
    final res = await repo.getWalkMediaByWalkId(2);
    expect(res?.isRight(), true);
  });
  test('remote failures map Left', () async {
    final repo = WalkMediaRepositoryImpl(
        walkMediaLocalDataSource: FakeLocal(),
        walkMediaRemoteDataSource: FakeRemoteFail(),
        networkInfo: FakeNet(true));
    expect(await repo.getWalkMedia(), Left(ServerFailure()));
  });
}
