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

  Future<String> _nameFromUid(String? uid) async {
    if (uid == null || uid.isEmpty) return '';
    try {
      final prof = await _firestore.collection('profiles').doc(uid).get();
      final pn = (prof.data()?['name'] as String?)?.trim();
      if (pn != null && pn.isNotEmpty) return pn;
    } catch (_) {}
    try {
      final user = await _firestore.collection('users').doc(uid).get();
      final un = (user.data()?['name'] as String?)?.trim();
      if (un != null && un.isNotEmpty) return un;
    } catch (_) {}
    return '';
  }

  Future<String> _currentUserRole() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 'standard';
    try {
      final snap = await _firestore.collection('users').doc(uid).get();
      return (snap.data()?['role'] as String?) ?? 'standard';
    } catch (_) {
      return 'standard';
    }
  }

  @override
  Future<List<RoutineModel>> getRoutines() async {
    try {
      final role = await _currentUserRole();
      final uid = _auth.currentUser?.uid;
      QuerySnapshot<Map<String, dynamic>> qs;
      try {
        if (role == 'trainer' && uid != null) {
          // Trainers: only their own routines
          qs = await _col
              .where('ownerUid', isEqualTo: uid)
              .orderBy('updatedAt', descending: true)
              .get();
        } else {
          // Others: all routines
          qs = await _col.orderBy('updatedAt', descending: true).get();
        }
      } on FirebaseException catch (e) {
        // Fallback without orderBy if composite index is missing
        if (e.code == 'failed-precondition' && role == 'trainer' && uid != null) {
          qs = await _col.where('ownerUid', isEqualTo: uid).get();
        } else {
          rethrow;
        }
      }

      final futures = qs.docs.map((d) async {
        final data = d.data();
        final exercises = _exerciseModelsFromList(data['exercises']);
        final ownerName = ((data['ownerName'] as String?) ?? '').trim();
        String resolvedName = ownerName;
        if (resolvedName.isEmpty) {
          // Try resolve from ownerUid -> profiles/users
          final ownerUid = (data['ownerUid'] as String?)?.trim();
          resolvedName = await _nameFromUid(ownerUid);
        }
        final fallbackSource = (data['source'] as String?) ?? '';
        return RoutineModel(
          id: (data['id'] as num?)?.toInt(),
          name: (data['name'] as String?) ?? '',
          description: (data['description'] as String?) ?? '',
          duration: (data['duration'] as num?)?.toInt() ?? 0,
          // Use trainer display name when available; fall back to stored source
          source: resolvedName.isNotEmpty ? resolvedName : fallbackSource,
          exercises: exercises,
        );
      }).toList();
      return await Future.wait(futures);
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> addRoutine(RoutineModel routineModel) async {
    try {
      final id = routineModel.id ?? DateTime.now().millisecondsSinceEpoch;
      final exercises = _exerciseMapsFromModels(routineModel.exercises
          .map((e) => e is ExerciseModel ? e : ExerciseModel.fromEntity(e))
          .toList());
      // Try to store owner's display name alongside UID for easy display later
      final uid = _auth.currentUser?.uid;
      final ownerName = await _nameFromUid(uid);
      await _col.add({
        'id': id,
        'ownerUid': uid,
        if (ownerName.isNotEmpty) 'ownerName': ownerName,
        'name': routineModel.name,
        'description': routineModel.description,
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
      final exercises = _exerciseMapsFromModels(routineModel.exercises
          .map((e) => e is ExerciseModel ? e : ExerciseModel.fromEntity(e))
          .toList());
      await qs.docs.first.reference.update({
        'name': routineModel.name,
        'description': routineModel.description,
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
