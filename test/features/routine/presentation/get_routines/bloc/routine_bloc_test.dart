import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';
import 'package:fitness_app/features/routine/domain/usecases/delete_routine.dart';
import 'package:fitness_app/features/routine/domain/usecases/get_routines.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/bloc/routine_list_bloc.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/bloc/routine_list_event.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/bloc/routine_list_state.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'routine_bloc_test.mocks.dart';

@GenerateMocks([GetRoutines, DeleteRoutine])
void main() {
  late RoutineListBloc bloc;
  late MockGetRoutines mockGetRoutines;
  late MockDeleteRoutine mockDeleteRoutine;

  setUp(() {
    mockGetRoutines = MockGetRoutines();
    mockDeleteRoutine = MockDeleteRoutine();

    bloc = RoutineListBloc(
        getRoutines: mockGetRoutines, deleteRoutine: mockDeleteRoutine);
  });

  test('initialState should be RoutineListInitialState', () async {
    //assert
    expect(bloc.initialState, equals(const RoutineListInitialState()));
  });

  group('GetRoutines', () {
    const tRoutines = [
      Routine(
        id: 37,
        name: 'string',
        description: 'This is for random',
        duration: 10,
        source: 'pre_loaded',
        exercises: [],
      )
    ];

    test('should get data from the routine usecase', () async* {
      //arrange

      when(mockGetRoutines(any))
          .thenAnswer((_) async => const Right(tRoutines));
      //act
      bloc.add(const RoutineListInitialEvent());
      await untilCalled(mockGetRoutines(any));

      //assert
      verify(mockGetRoutines(any));
    });
    test('should emits [Loading, Loaded] when data is gotten successfully',
        () async* {
      //arrange

      when(mockGetRoutines(any))
          .thenAnswer((_) async => const Right(tRoutines));

      //assert later
      final expected = [
        const RoutineListInitialState(),
        const RoutineListLoadingState(),
        const RoutineListLoadedSuccessState(tRoutines)
      ];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(const RoutineListInitialEvent());
    });
    test('should emits [Loading, Error] when getting data fails', () async* {
      //arrange

      when(mockGetRoutines(any)).thenAnswer((_) async => Left(ServerFailure()));

      //assert later
      final expected = [
        const RoutineListInitialState(),
        const RoutineListLoadingState(),
        const RoutineListErrorState(message: AppStringsEn.serverFailure)
      ];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(const RoutineListInitialEvent());
    });

    test(
        'should emits [Loading, Error] with a proper message for the error when getting data fails',
        () async* {
      //arrange

      when(mockGetRoutines(any)).thenAnswer((_) async => Left(CacheFailure()));

      //assert later
      final expected = [
        const RoutineListInitialState(),
        const RoutineListLoadingState(),
        const RoutineListErrorState(message: AppStringsEn.cacheFailure)
      ];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(const RoutineListInitialEvent());
    });
  });

  group('DeleteRoutine', () {
    const tRoutine = Routine(
      id: 37,
      name: 'string',
      description: 'This is for random',
      duration: 10,
      source: 'pre_loaded',
      exercises: [],
    );

    test('should get int from the delete usecase', () async* {
      //arrange
      when(mockDeleteRoutine.call(tRoutine.id!))
          .thenAnswer((_) async => const Right(1));
      //act
      bloc.add(const RoutineListDeleteButtonClickedEvent(routine: tRoutine));
      await untilCalled(mockDeleteRoutine.call(any));

      //assert
      verify(mockDeleteRoutine.call(tRoutine.id!));
    });
    test('should emits [Loading, Loaded] when data is gotten successfully',
        () async* {
      //arrange
      when(mockDeleteRoutine.call(tRoutine.id!))
          .thenAnswer((_) async => const Right(1));

      //assert later
      final expected = [
        const RoutineListInitialState(),
        const RoutineListLoadingState(),
        const RoutineListLoadedSuccessState([tRoutine])
      ];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(const RoutineListDeleteButtonClickedEvent(routine: tRoutine));
    });
    test('should emits [Loading, Error] when getting data fails', () async* {
      //arrange
      when(mockDeleteRoutine.call(tRoutine.id!))
          .thenAnswer((_) async => Left(ServerFailure()));

      //assert later
      final expected = [
        const RoutineListInitialState(),
        const RoutineListLoadingState(),
        const RoutineListErrorState(message: AppStringsEn.serverFailure)
      ];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(const RoutineListDeleteButtonClickedEvent(routine: tRoutine));
    });

    test(
        'should emits [Loading, Error] with a proper message for the error when getting data fails',
        () async* {
      //arrange
      when(mockDeleteRoutine.call(tRoutine.id!))
          .thenAnswer((_) async => Left(CacheFailure()));

      //assert later
      final expected = [
        const RoutineListInitialState(),
        const RoutineListLoadingState(),
        const RoutineListErrorState(message: AppStringsEn.cacheFailure)
      ];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(const RoutineListDeleteButtonClickedEvent(routine: tRoutine));
    });
  });
}
