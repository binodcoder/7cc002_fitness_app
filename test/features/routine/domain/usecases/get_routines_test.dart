import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/home/data/models/routine_model.dart';
import 'package:fitness_app/features/home/domain/repositories/home_repositories.dart';
import 'package:fitness_app/features/home/domain/usecases/get_routines.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockRoutineRepository extends Mock implements HomeRepository {}

void main() {
  late GetRoutines usecase;
  late MockRoutineRepository mockRoutineRepository;
  setUp(() {
    mockRoutineRepository = MockRoutineRepository();
    usecase = GetRoutines(mockRoutineRepository);
  });

  List<RoutineModel> tRoutine = const [
    RoutineModel(
      id: 1,
      description: '',
      duration: 0,
      name: '',
      source: '',
    )
  ];
  test(
    'should get all blog post from the repository',
    () async {
      when(mockRoutineRepository.getRoutines())
          .thenAnswer((_) async => Right(tRoutine));
      final result = await usecase(NoParams());
      expect(result, Right(tRoutine));
      verify(mockRoutineRepository.getRoutines());
      verifyNoMoreInteractions(mockRoutineRepository);
    },
  );
}
