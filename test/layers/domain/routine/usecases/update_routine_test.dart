import 'package:fitness_app/features/routine/data/models/routine_model.dart';
import 'package:fitness_app/features/routine/domain/repositories/routine_repositories.dart';
import 'package:fitness_app/features/routine/domain/usecases/update_routine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockRoutineRepository extends Mock implements RoutineRepository {}

void main() {
  late UpdateRoutine usecase;
  late MockRoutineRepository mockRoutineRepository;
  setUp(() {
    mockRoutineRepository = MockRoutineRepository();
    usecase = UpdateRoutine(mockRoutineRepository);
  });

  int tResponse = 1;

  RoutineModel tRoutineModel = const RoutineModel(
    id: 1,
    description: '',
    difficulty: '',
    duration: 0,
    name: '',
    source: '',
  );

  test(
    'should get int from the repository',
    () async {
      when(mockRoutineRepository.updateRoutine(tRoutineModel))
          .thenAnswer((_) async => Right(tResponse));
      final result = await usecase(tRoutineModel);
      expect(result, Right(tResponse));
      verify(mockRoutineRepository.updateRoutine(tRoutineModel));
      verifyNoMoreInteractions(mockRoutineRepository);
    },
  );
}
