import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';
import 'package:fitness_app/features/routine/domain/usecases/add_routine.dart';
import 'package:fitness_app/features/routine/domain/usecases/update_routine.dart';
import 'package:fitness_app/features/routine/presentation/routine_form/bloc/routine_form_bloc.dart';
import 'package:fitness_app/features/routine/presentation/routine_form/bloc/routine_form_event.dart';
import 'package:fitness_app/features/routine/presentation/routine_form/bloc/routine_form_state.dart';

import 'routine_form_bloc_test.mocks.dart';

@GenerateMocks([AddRoutine, UpdateRoutine])
void main() {
  late RoutineFormBloc bloc;
  late MockAddRoutine mockAddRoutine;
  late MockUpdateRoutine mockUpdateRoutine;

  const tRoutine = Routine(
    id: 1,
    name: 'name',
    description: 'desc',
    difficulty: 'easy',
    duration: 5,
    source: 'pre_loaded',
    exercises: [],
  );

  setUp(() {
    mockAddRoutine = MockAddRoutine();
    mockUpdateRoutine = MockUpdateRoutine();
    bloc = RoutineFormBloc(addRoutine: mockAddRoutine, updateRoutine: mockUpdateRoutine);
  });

  test('initial state is RoutineFormInitialState', () {
    expect(bloc.state, const RoutineFormInitialState());
  });

  group('Save', () {
    test('emits [Loading, Saved] on success', () async {
      when(mockAddRoutine(tRoutine)).thenAnswer((_) async => const Right(1));

      final expected = [
        const RoutineFormLoadingState(),
        const RoutineFormSavedActionState(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const RoutineFormSaveButtonPressEvent(newRoutine: tRoutine));
    });

    test('emits [Loading, Error] on failure', () async {
      when(mockAddRoutine(tRoutine)).thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        const RoutineFormLoadingState(),
        const RoutineFormErrorState(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const RoutineFormSaveButtonPressEvent(newRoutine: tRoutine));
    });
  });

  group('Update', () {
    test('emits [Loading, Updated] on success', () async {
      when(mockUpdateRoutine(tRoutine)).thenAnswer((_) async => const Right(1));

      final expected = [
        const RoutineFormLoadingState(),
        const RoutineFormUpdatedActionState(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const RoutineFormUpdateButtonPressEvent(updatedRoutine: tRoutine));
    });

    test('emits [Loading, Error] on failure', () async {
      when(mockUpdateRoutine(tRoutine)).thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        const RoutineFormLoadingState(),
        const RoutineFormErrorState(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const RoutineFormUpdateButtonPressEvent(updatedRoutine: tRoutine));
    });
  });
}

