import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:fitness_app/features/live_training/data/datasources/live_training_local_data_source.dart';
import 'package:fitness_app/features/live_training/data/datasources/live_training_remote_data_source.dart';
import 'package:fitness_app/features/live_training/data/models/live_training_model.dart';
import 'package:fitness_app/features/live_training/data/repositories/live_training_repository_impl.dart';
import 'package:fitness_app/core/errors/exceptions.dart';

class FakeNet implements NetworkInfo { FakeNet(this.connected); bool connected; @override Future<bool> get isConnected async => connected; }

class FakeLocal implements LiveTrainingLocalDataSource {
  List<LiveTrainingModel> items = const [];
  @override
  Future<List<LiveTrainingModel>> getLiveTrainings() async => items;
}

class FakeRemoteOk implements LiveTrainingRemoteDataSource {
  @override
  Future<int> addLiveTraining(LiveTrainingModel liveTrainingModel) async => 1;
  @override
  Future<int> deleteLiveTraining(int liveTrainingId) async => 1;
  @override
  Future<List<LiveTrainingModel>> getLiveTrainings() async => const [];
  @override
  Future<int> updateLiveTraining(LiveTrainingModel liveTrainingModel) async => 1;
}

class FakeRemoteFail implements LiveTrainingRemoteDataSource {
  @override
  Future<int> addLiveTraining(LiveTrainingModel liveTrainingModel) async => throw ServerException();
  @override
  Future<int> deleteLiveTraining(int liveTrainingId) async => throw ServerException();
  @override
  Future<List<LiveTrainingModel>> getLiveTrainings() async => throw ServerException();
  @override
  Future<int> updateLiveTraining(LiveTrainingModel liveTrainingModel) async => throw ServerException();
}

void main() {
  test('online returns remote list', () async {
    final repo = LiveTrainingRepositoryImpl(
      liveTrainingLocalDataSource: FakeLocal(),
      liveTrainingRemoteDataSource: FakeRemoteOk(),
      networkInfo: FakeNet(true),
    );
    final res = await repo.getLiveTrainings();
    expect(res, isNotNull);
    res!.fold((l) => fail('Expected Right'), (r) => expect(r, []));
  });

  test('offline returns local list', () async {
    final local = FakeLocal()..items = [LiveTrainingModel(trainerId: 1, title: 't', description: 'd', trainingDate: DateTime(2025, 1, 1), startTime: '09:00', endTime: '10:00')];
    final repo = LiveTrainingRepositoryImpl(
      liveTrainingLocalDataSource: local,
      liveTrainingRemoteDataSource: FakeRemoteOk(),
      networkInfo: FakeNet(false),
    );
    final res = await repo.getLiveTrainings();
    expect(res!.isRight(), true);
  });

  test('remote failures map to Left', () async {
    final repo = LiveTrainingRepositoryImpl(
      liveTrainingLocalDataSource: FakeLocal(),
      liveTrainingRemoteDataSource: FakeRemoteFail(),
      networkInfo: FakeNet(true),
    );
    expect(await repo.getLiveTrainings(), Left(ServerFailure()));
    expect(await repo.addLiveTraining(LiveTrainingModel(trainerId: 1, title: 't', description: 'd', trainingDate: DateTime(2025, 1, 1), startTime: '09:00', endTime: '10:00')), Left(ServerFailure()));
  });
}
