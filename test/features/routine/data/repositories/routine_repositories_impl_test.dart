import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:fitness_app/features/routine/data/data_sources/routines_local_data_source.dart';
import 'package:fitness_app/features/routine/data/data_sources/routines_remote_data_source.dart';
import 'package:fitness_app/features/routine/data/models/routine_model.dart';
import 'package:fitness_app/features/routine/data/repositories/routine_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'routine_repositories_impl_test.mock.dart';

class FakeRoutinesLocalDataSource implements RoutinesLocalDataSource {
  List<RoutineModel> _items = const [];

  @override
  Future<void> cacheRoutine(RoutineModel routineModel) async {
    _items = [
      ..._items.where((e) => e.id != routineModel.id),
      routineModel,
    ];
  }

  @override
  Future<void> cacheRoutines(List<RoutineModel> routines) async {
    _items = List<RoutineModel>.from(routines);
  }

  @override
  Future<void> clearRoutines() async {
    _items = const [];
  }

  @override
  Future<List<RoutineModel>> getLastRoutines() async {
    return _items;
  }
}

@GenerateMocks([NetworkInfo])
@GenerateMocks([
  RoutineRemoteDataSource
], customMocks: [
  MockSpec<RoutineRemoteDataSource>(
      as: #MockRoutinesRemoteDataSourceForTest,
      onMissingStub: OnMissingStub.returnDefault),
])
void main() {
  late RoutineRepositoryImpl repository;
  late MockRoutinesRemoteDataSource mockRemoteDataSource;
  late FakeRoutinesLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRoutinesRemoteDataSource();
    mockLocalDataSource = FakeRoutinesLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = RoutineRepositoryImpl(
      routineRemoteDataSource: mockRemoteDataSource,
      routineLocalDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // Provide safe defaults for local interactions
        // No stubbing needed for fake local data source
      });
      body();
    });
  }

  group('getRoutines', () {
    const tRoutineModel = [
      RoutineModel(
        id: 37,
        name: 'string',
        description: 'This is for random',
        difficulty: 'easy',
        duration: 10,
        source: 'pre_loaded',
        exercises: [],
      )
    ];

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getRoutines();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getRoutines())
            .thenAnswer((_) async => tRoutineModel);
        //act
        final result = await repository.getRoutines();
        //assert
        verify(mockRemoteDataSource.getRoutines());
        expect(result, isNotNull);
        result.fold(
          (l) => fail('Expected Right but got Left'),
          (r) => expect(r, tRoutineModel),
        );
      });
      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getRoutines())
            .thenAnswer((_) async => tRoutineModel);
        //act
        await repository.getRoutines();
        //assert
        verify(mockRemoteDataSource.getRoutines());
        final cached = await mockLocalDataSource.getLastRoutines();
        expect(cached, tRoutineModel);
      });
      test(
          'should return serverfailure when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getRoutines()).thenThrow(ServerException());
        //act
        final result = await repository.getRoutines();
        //assert
        verify(mockRemoteDataSource.getRoutines());
        final cached = await mockLocalDataSource.getLastRoutines();
        expect(cached, isEmpty);
        expect(result, equals(Left(ServerFailure())));
      });
    });
  });
}
