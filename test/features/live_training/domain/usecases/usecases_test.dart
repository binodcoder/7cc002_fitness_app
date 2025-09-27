import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/live_training/domain/repositories/live_training_repositories.dart';
import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';
import 'package:fitness_app/features/live_training/domain/usecases/get_live_trainings.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/live_training/domain/usecases/add_live_training.dart';
import 'package:fitness_app/features/live_training/domain/usecases/update_live_training.dart';
import 'package:fitness_app/features/live_training/domain/usecases/delete_live_training.dart';

class MockRepo extends Mock implements LiveTrainingRepository {}

void main() {
  final repo = MockRepo();
  final getUse = GetLiveTrainings(repo);
  final addUse = AddLiveTraining(repo);
  final updateUse = UpdateLiveTraining(repo);
  final delUse = DeleteLiveTraining(repo);

  final e = LiveTraining(
    trainerId: 1,
    title: 't',
    description: 'd',
    trainingDate: DateTime(2025, 1, 1),
    startTime: '09:00',
    endTime: '10:00',
  );

  test('usecases call repo and return Right', () async {
    when(repo.getLiveTrainings()).thenAnswer((_) async => const Right(<LiveTraining>[]));
    when(repo.addLiveTraining(e)).thenAnswer((_) async => const Right(1));
    when(repo.updateLiveTraining(e)).thenAnswer((_) async => const Right(1));
    when(repo.deleteLiveTraining(1)).thenAnswer((_) async => const Right(1));

    expect(await getUse(NoParams()), const Right(<LiveTraining>[]));
    expect(await addUse(e), const Right(1));
    expect(await updateUse(e), const Right(1));
    expect(await delUse(1), const Right(1));
  });
}
