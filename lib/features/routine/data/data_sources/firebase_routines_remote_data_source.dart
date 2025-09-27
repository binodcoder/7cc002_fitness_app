import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/routine/data/data_sources/routines_remote_data_source.dart';
import 'package:fitness_app/features/routine/data/models/routine_model.dart';

class FirebaseRoutineRemoteDataSourceImpl implements RoutineRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('routines');

  @override
  Future<List<RoutineModel>> getRoutines() async {
    try {
      final qs = await _col.orderBy('updatedAt', descending: true).get();
      return qs.docs.map((d) {
        final data = d.data();
        return RoutineModel(
          id: (data['id'] as num?)?.toInt(),
          name: (data['name'] as String?) ?? '',
          description: (data['description'] as String?) ?? '',
          difficulty: (data['difficulty'] as String?) ?? '',
          duration: (data['duration'] as num?)?.toInt() ?? 0,
          source: (data['source'] as String?) ?? '',
          exercises: const [],
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
      await _col.add({
        'id': id,
        'name': routineModel.name,
        'description': routineModel.description,
        'difficulty': routineModel.difficulty,
        'duration': routineModel.duration,
        'source': routineModel.source,
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
      final qs = await _col.where('id', isEqualTo: routineModel.id).limit(1).get();
      if (qs.docs.isEmpty) throw ServerException();
      await qs.docs.first.reference.update({
        'name': routineModel.name,
        'description': routineModel.description,
        'difficulty': routineModel.difficulty,
        'duration': routineModel.duration,
        'source': routineModel.source,
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

