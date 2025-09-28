import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:fitness_app/features/walk/data/data_sources/walks_local_data_source.dart';
import 'package:fitness_app/features/walk/data/data_sources/walks_remote_data_source.dart';
import 'package:fitness_app/features/walk/data/models/walk_model.dart';
import 'package:fitness_app/features/walk/data/repositories/walk_repository_impl.dart';
import 'package:fitness_app/core/errors/exceptions.dart';

class FakeNet implements NetworkInfo {
  FakeNet(this.connected);
  bool connected;
  @override
  Future<bool> get isConnected async => connected;
}

class FakeLocal implements WalksLocalDataSource {
  List<WalkModel> items = const [];
  @override
  Future<List<WalkModel>> getWalks() async => items;
}

class FakeRemoteOk implements WalkRemoteDataSource {
  @override
  Future<int> addWalk(WalkModel walkModel) async => 1;
  @override
  Future<int> deleteWalk(int userId) async => 1;
  @override
  Future<List<WalkModel>> getWalks() async => const [];
  @override
  Future<int> updateWalk(WalkModel walkModel) async => 1;
  @override
  Future<int> joinWalk(walkParticipantModel) async => 1;
  @override
  Future<int> leaveWalk(walkParticipantModel) async => 1;
}

class FakeRemoteFail implements WalkRemoteDataSource {
  @override
  Future<int> addWalk(WalkModel walkModel) async => throw ServerException();
  @override
  Future<int> deleteWalk(int userId) async => throw ServerException();
  @override
  Future<List<WalkModel>> getWalks() async => throw ServerException();
  @override
  Future<int> updateWalk(WalkModel walkModel) async => throw ServerException();
  @override
  Future<int> joinWalk(walkParticipantModel) async => throw ServerException();
  @override
  Future<int> leaveWalk(walkParticipantModel) async => throw ServerException();
}

void main() {
  test('online maps remote', () async {
    final repo = WalkRepositoryImpl(
        walkLocalDataSource: FakeLocal(),
        walkRemoteDataSource: FakeRemoteOk(),
        networkInfo: FakeNet(true));
    final res = await repo.getWalks();
    expect(res, isNotNull);
    res.fold((l) => fail('Expected Right'), (r) => expect(r, []));
    expect(
      await repo.addWalk(WalkModel(
        id: 1,
        proposerId: 2,
        routeData: 'enc',
        date: DateTime(2025, 1, 1),
        startTime: '09:00',
        startLocation: 'Campus',
      )),
      const Right(1),
    );
  });
  test('offline maps local', () async {
    final local = FakeLocal()
      ..items = [
        WalkModel(
          id: 1,
          proposerId: 2,
          routeData: 'enc',
          date: DateTime(2025, 1, 1),
          startTime: '09:00',
          startLocation: 'Campus',
        )
      ];
    final repo = WalkRepositoryImpl(
        walkLocalDataSource: local,
        walkRemoteDataSource: FakeRemoteOk(),
        networkInfo: FakeNet(false));
    final res = await repo.getWalks();
    expect(res.isRight(), true);
  });
  test('remote failure maps Left', () async {
    final repo = WalkRepositoryImpl(
        walkLocalDataSource: FakeLocal(),
        walkRemoteDataSource: FakeRemoteFail(),
        networkInfo: FakeNet(true));
    expect(await repo.getWalks(), Left(ServerFailure()));
  });
}
