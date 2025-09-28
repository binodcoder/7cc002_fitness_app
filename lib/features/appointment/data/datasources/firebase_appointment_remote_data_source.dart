import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/appointment/data/datasources/appointment_data_source.dart';
import 'package:fitness_app/features/appointment/data/models/appointment_model.dart';

class FirebaseAppointmentRemoteDataSource implements AppointmentDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection('users').doc(uid).collection('appointments');

  String _uidOrThrow() {
    final u = _auth.currentUser;
    if (u == null) throw ServerException();
    return u.uid;
  }

  Future<int> _currentUserNumericId() async {
    final uid = _uidOrThrow();
    final snap = await _firestore.collection('users').doc(uid).get();
    return (snap.data()?['id'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<int> addAppointment(AppointmentModel appointmentModel) async {
    try {
      final uid = _uidOrThrow();
      final id = appointmentModel.id ?? DateTime.now().millisecondsSinceEpoch;
      final numericUserId = appointmentModel.userId == 0
          ? await _currentUserNumericId()
          : appointmentModel.userId;
      await _col(uid).doc(id.toString()).set({
        'id': id,
        'ownerUid': uid,
        'date': Timestamp.fromDate(appointmentModel.date),
        'startTime': appointmentModel.startTime,
        'endTime': appointmentModel.endTime,
        'trainerId': appointmentModel.trainerId,
        'userId': numericUserId,
        'remark': appointmentModel.remark,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> updateAppointment(AppointmentModel appointmentModel) async {
    try {
      final uid = _uidOrThrow();
      if (appointmentModel.id == null) throw ServerException();
      final doc = _col(uid).doc(appointmentModel.id.toString());
      await doc.update({
        'date': Timestamp.fromDate(appointmentModel.date),
        'startTime': appointmentModel.startTime,
        'endTime': appointmentModel.endTime,
        'trainerId': appointmentModel.trainerId,
        'userId': appointmentModel.userId,
        'remark': appointmentModel.remark,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> deleteAppointment(int appointmentId) async {
    try {
      final uid = _uidOrThrow();
      await _col(uid).doc(appointmentId.toString()).delete();
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final uid = _uidOrThrow();
      final qs = await _col(uid).orderBy('date', descending: true).get();
      return qs.docs.map((d) {
        final data = d.data();
        final ts = data['date'];
        final date = ts is Timestamp
            ? ts.toDate()
            : DateTime.tryParse((ts ?? '').toString()) ?? DateTime.now();
        return AppointmentModel(
          id: (data['id'] as num?)?.toInt(),
          date: date,
          startTime: (data['startTime'] as String?) ?? '',
          endTime: (data['endTime'] as String?) ?? '',
          trainerId: (data['trainerId'] as num?)?.toInt() ?? 0,
          userId: (data['userId'] as num?)?.toInt() ?? 0,
          remark: (data['remark'] as String?),
        );
      }).toList();
    } on FirebaseException {
      throw ServerException();
    }
  }
}
