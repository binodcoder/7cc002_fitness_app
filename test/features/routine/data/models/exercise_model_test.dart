import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/home/data/models/exercise_model.dart';
import 'package:fitness_app/features/home/domain/entities/exercise.dart';

void main() {
  const tModel = ExerciseModel(
    id: 1,
    name: 'Push Up',
    description: 'desc',
    targetMuscleGroups: 'chest',
    difficulty: ExerciseDifficulty.easy,
    equipment: 'none',
    imageUrl: 'img',
    videoUrl: 'vid',
  );

  test('should be a subclass of Exercise', () {
    expect(tModel, isA<Exercise>());
  });

  test('fromJson returns valid model', () {
    final jsonMap = {
      'id': 1,
      'name': 'Push Up',
      'description': 'desc',
      'targetMuscleGroups': 'chest',
      'difficulty': 'easy',
      'equipment': 'none',
      'imageUrl': 'img',
      'videoUrl': 'vid',
    };
    final result = ExerciseModel.fromJson(jsonMap);
    expect(result, tModel);
  });

  test('toJson returns proper map', () {
    final jsonResult = tModel.toJson();
    final reparsed =
        ExerciseModel.fromJson(json.decode(json.encode(jsonResult)));
    expect(reparsed, tModel);
  });

  test('fromEntity returns same content', () {
    const entity = Exercise(
      id: 1,
      name: 'Push Up',
      description: 'desc',
      targetMuscleGroups: 'chest',
      difficulty: ExerciseDifficulty.easy,
      equipment: 'none',
      imageUrl: 'img',
      videoUrl: 'vid',
    );
    final model = ExerciseModel.fromEntity(entity);
    expect(model, tModel);
  });
}
