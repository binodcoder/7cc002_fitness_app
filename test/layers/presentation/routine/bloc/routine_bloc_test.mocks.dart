// Mocks generated by Mockito 5.4.2 from annotations
// in fitness_app/test/layers/presentation/routine/bloc/routine_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as i5;

import 'package:fitness_app/core/errors/failures.dart' as i6;
import 'package:fitness_app/core/usecases/usecase.dart' as i9;
import 'package:fitness_app/core/model/routine_model.dart' as i7;
import 'package:fitness_app/layers/domain/routine/repositories/routine_repositories.dart' as i2;
import 'package:fitness_app/layers/domain/routine/usecases/delete_routine.dart' as i4;
import 'package:fitness_app/layers/domain/routine/usecases/get_routines.dart' as i8;
import 'package:dartz/dartz.dart' as i3;
import 'package:mockito/mockito.dart' as i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeRoutineRepository_0 extends i1.Fake implements i2.RoutineRepository {}

/// A class which mocks [DeleteRoutine].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeleteRoutine extends i1.Mock implements i4.DeleteRoutine {
  MockDeleteRoutine(any) {
    i1.throwOnMissingStub(this);
  }
  int id = 1;

  @override
  i5.Future<i3.Either<i6.Failure, int>?> call(id) =>
      (super.noSuchMethod(Invocation.method(#call, [int]), returnValue: Future<i3.Either<i6.Failure, int>?>.value())
          as i5.Future<i3.Either<i6.Failure, int>?>);
}

/// A class which mocks [GetRoutines].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetRoutines extends i1.Mock implements i8.GetRoutines {
  MockGetRoutines() {
    i1.throwOnMissingStub(this);
  }

  @override
  i2.RoutineRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository), returnValue: _FakeRoutineRepository_0()) as i2.RoutineRepository);
  @override
  i5.Future<i3.Either<i6.Failure, List<i7.RoutineModel>>?> call(i9.NoParams? noParams) =>
      (super.noSuchMethod(Invocation.method(#call, [noParams]), returnValue: Future<i3.Either<i6.Failure, List<i7.RoutineModel>>?>.value())
          as i5.Future<i3.Either<i6.Failure, List<i7.RoutineModel>>?>);
}
