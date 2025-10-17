import 'package:fitness_app/features/home/data/models/routine_model.dart';
import 'package:fitness_app/features/home/domain/repositories/home_repositories.dart';
import 'package:fitness_app/features/home/domain/usecases/delete_routine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockRoutineRepository extends Mock implements HomeRepository {}

void main() {
  late DeleteRoutine usecase;
  late MockRoutineRepository mockRoutineRepository;
  setUp(() {
    mockRoutineRepository = MockRoutineRepository();
    usecase = DeleteRoutine(mockRoutineRepository);
  });

  int tResponse = 1;

  RoutineModel tRoutineModel = const RoutineModel(
    id: 1,
    description: '',
    duration: 0,
    name: '',
    source: '',
  );

  test(
    'should get int from the repository',
    () async {
      when(mockRoutineRepository.deleteRoutine(tRoutineModel.id!))
          .thenAnswer((_) async => Right(tResponse));
      final result = await usecase(tRoutineModel.id!);
      expect(result, Right(tResponse));
      verify(mockRoutineRepository.deleteRoutine(tRoutineModel.id!));
      verifyNoMoreInteractions(mockRoutineRepository);
    },
  );
}
