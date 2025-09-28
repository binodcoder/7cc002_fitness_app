import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/live_training/data/datasources/live_training_data_source.dart';
import 'package:fitness_app/features/live_training/data/models/live_training_model.dart';

class FirebaseLiveTrainingRemoteDataSource implements LiveTrainingDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('live_trainings');

  int _currentUserNumericId(Map<String, dynamic>? profile) {
    return (profile?['id'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<List<LiveTrainingModel>> getLiveTrainings() async {
    try {
      final qs = await _col.orderBy('trainingDate', descending: true).get();
      return qs.docs.map((d) {
        final data = d.data();
        final dt = data['trainingDate'];
        final date = dt is Timestamp
            ? dt.toDate()
            : DateTime.tryParse((dt ?? '').toString()) ?? DateTime.now();
        return LiveTrainingModel(
          trainerId: (data['trainerId'] as num?)?.toInt() ?? 0,
          title: (data['title'] as String?) ?? '',
          description: (data['description'] as String?) ?? '',
          trainingDate: date,
          startTime: (data['startTime'] as String?) ?? '',
          endTime: (data['endTime'] as String?) ?? '',
        );
      }).toList();
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> addLiveTraining(LiveTrainingModel liveTrainingModel) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw ServerException();
      // Optional: read numeric id from user doc
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final numericId = _currentUserNumericId(userDoc.data());
      await _col.add({
        'trainerId': liveTrainingModel.trainerId != 0
            ? liveTrainingModel.trainerId
            : numericId,
        'title': liveTrainingModel.title,
        'description': liveTrainingModel.description,
        'trainingDate': Timestamp.fromDate(liveTrainingModel.trainingDate),
        'startTime': liveTrainingModel.startTime,
        'endTime': liveTrainingModel.endTime,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> updateLiveTraining(LiveTrainingModel liveTrainingModel) async {
    try {
      // Mirror existing behavior: update first doc with matching trainerId
      final qs = await _col
          .where('trainerId', isEqualTo: liveTrainingModel.trainerId)
          .limit(1)
          .get();
      if (qs.docs.isEmpty) throw ServerException();
      await qs.docs.first.reference.update({
        'title': liveTrainingModel.title,
        'description': liveTrainingModel.description,
        'trainingDate': Timestamp.fromDate(liveTrainingModel.trainingDate),
        'startTime': liveTrainingModel.startTime,
        'endTime': liveTrainingModel.endTime,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> deleteLiveTraining(int liveTrainingId) async {
    try {
      // Mirror existing behavior: delete first doc with matching trainerId
      final qs = await _col
          .where('trainerId', isEqualTo: liveTrainingId)
          .limit(1)
          .get();
      if (qs.docs.isEmpty) throw ServerException();
      await qs.docs.first.reference.delete();
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }
}
