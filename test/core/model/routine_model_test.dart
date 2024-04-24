import 'package:fitness_app/core/model/routine_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import '../../fixtures/fixture_reader.dart';

void main() {
  final tRoutineModel = RoutineModel(
    id: 37,
    name: 'string',
    description: 'This is for random',
    difficulty: 'easy',
    duration: 10,
    source: 'pre_loaded',
    exercises: [],
  );

  test('should be a subclass of Routine model', () async {
    //assert
    expect(tRoutineModel, isA<RoutineModel>());
  });

  group('fromJson', () {
    test('should return a valid model', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('routine.json'));
      //act
      final result = RoutineModel.fromJson(jsonMap);
      //assert
      expect(result.id, equals(tRoutineModel.id));
    });
    test('should return a valid model when the JSON duration is regarded as a double', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('routine_duration_double.json'));
      //act
      final result = RoutineModel.fromJson(jsonMap);
      //assert
      expect(result, equals(tRoutineModel));
    });
  });

  group('toJson', () {
    test('should return ', () async {
      //act
      final result = tRoutineModel.toJson();
      //assert
      final expectedMap = {
        "id": 37,
        "name": "string",
        "description": "This is for random",
        "difficulty": "easy",
        "duration": 10,
        "source": "pre_loaded",
        "exercises": []
      };
      expect(result, equals(expectedMap));
    });
  });
}
