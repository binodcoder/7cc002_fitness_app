import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/network/network_info.dart';
import 'package:fitness_app/features/home/data/data_sources/home_local_data_source.dart';
import 'package:fitness_app/features/home/data/data_sources/home_rest_data_source.dart';
import 'package:fitness_app/features/home/data/models/routine_model.dart';
import 'package:fitness_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'routine_repositories_impl_test.mock.dart';

class FakeRoutinesLocalDataSource implements HomeLocalDataSource {
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
  late HomeRepositoryImpl repository;
  late MockRoutinesRemoteDataSource mockRemoteDataSource;
  late FakeRoutinesLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRoutinesRemoteDataSource();
    mockLocalDataSource = FakeRoutinesLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = HomeRepositoryImpl(
      homeRemoteDataSource: mockRemoteDataSource,
      homeLocalDataSource: mockLocalDataSource,
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
