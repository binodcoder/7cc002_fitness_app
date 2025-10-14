import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/routine/data/data_sources/routine_data_source.dart';
import 'package:fitness_app/features/routine/data/models/routine_model.dart';
import 'package:fitness_app/features/routine/data/models/exercise_model.dart';

class FirebaseRoutineRemoteDataSourceImpl implements RoutineDataSource {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  fb.FirebaseAuth get _auth => fb.FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('routines');

  List<ExerciseModel> _exerciseModelsFromList(dynamic list) {
    final raw = (list as List?) ?? const [];
    return raw
        .whereType<dynamic>()
        .map((e) => (e as Map?)?.cast<String, dynamic>() ?? const {})
        .map((m) {
      return ExerciseModel.fromJson({
        'id': (m['id'] as num?)?.toInt() ?? 0,
        'name': (m['name'] ?? '').toString(),
        'description': (m['description'] ?? '').toString(),
        'targetMuscleGroups': (m['targetMuscleGroups'] ?? '').toString(),
        'difficulty': (m['difficulty'] ?? '').toString(),
        'equipment': (m['equipment'] ?? '').toString(),
        'imageUrl': (m['imageUrl'] ?? '').toString(),
        'videoUrl': (m['videoUrl'] ?? '').toString(),
      });
    }).toList();
  }

  List<Map<String, dynamic>> _exerciseMapsFromModels(List<ExerciseModel> list) {
    return list.map((e) => e.toJson()).toList();
  }

  @override
  Future<List<RoutineModel>> getRoutines() async {
    try {
      final qs = await _col.orderBy('updatedAt', descending: true).get();
      return qs.docs.map((d) {
        final data = d.data();
        final exercises = _exerciseModelsFromList(data['exercises']);
        return RoutineModel(
          id: (data['id'] as num?)?.toInt(),
          name: (data['name'] as String?) ?? '',
          description: (data['description'] as String?) ?? '',
          difficulty: (data['difficulty'] as String?) ?? '',
          duration: (data['duration'] as num?)?.toInt() ?? 0,
          source: (data['source'] as String?) ?? '',
          exercises: exercises,
        );
      }).toList();
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> addRoutine(RoutineModel routineModel) async {
    try {
      final id = routineModel.id ?? DateTime.now().millisecondsSinceEpoch;
      final exercises = _exerciseMapsFromModels(
          routineModel.exercises.map((e) => e is ExerciseModel ? e : ExerciseModel.fromEntity(e)).toList());
      await _col.add({
        'id': id,
        'ownerUid': _auth.currentUser?.uid,
        'name': routineModel.name,
        'description': routineModel.description,
        'difficulty': routineModel.difficulty,
        'duration': routineModel.duration,
        'source': routineModel.source,
        'exercises': exercises,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> updateRoutine(RoutineModel routineModel) async {
    try {
      if (routineModel.id == null) throw ServerException();
      final qs =
          await _col.where('id', isEqualTo: routineModel.id).limit(1).get();
      if (qs.docs.isEmpty) throw ServerException();
      final exercises = _exerciseMapsFromModels(
          routineModel.exercises.map((e) => e is ExerciseModel ? e : ExerciseModel.fromEntity(e)).toList());
      await qs.docs.first.reference.update({
        'name': routineModel.name,
        'description': routineModel.description,
        'difficulty': routineModel.difficulty,
        'duration': routineModel.duration,
        'source': routineModel.source,
        'exercises': exercises,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> deleteRoutine(int routineId) async {
    try {
      final qs = await _col.where('id', isEqualTo: routineId).limit(1).get();
      if (qs.docs.isEmpty) throw ServerException();
      await qs.docs.first.reference.delete();
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }
}
