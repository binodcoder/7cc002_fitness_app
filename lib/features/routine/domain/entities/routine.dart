import 'package:equatable/equatable.dart';
import 'exercise.dart';

class Routine extends Equatable {
  final int? id;
  final String name;
  final String description;
  final String difficulty;
  final int duration;
  final String source;
  final List<Exercise> exercises;

  const Routine({
    this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.duration,
    required this.source,
    this.exercises = const [],
  });

  @override
  List<Object?> get props =>
      [id, name, description, difficulty, duration, source, exercises];
}
