import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/appointment/data/datasources/appointment_data_source.dart';
import 'package:fitness_app/features/appointment/data/models/appointment_model.dart';

class FirebaseAppointmentRemoteDataSource implements AppointmentDataSource {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  fb.FirebaseAuth get _auth => fb.FirebaseAuth.instance;

  // Top-level appointments collection for simpler cross-role querying
  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('appointments');

  String _uidOrThrow() {
    final u = _auth.currentUser;
    if (u == null) throw ServerException();
    return u.uid;
  }

  Future<Map<String, String>> _trainerUidEmailByNumericId(int trainerId) async {
    try {
      final qs = await _firestore
          .collection('users')
          .where('id', isEqualTo: trainerId)
          .limit(1)
          .get();
      if (qs.docs.isEmpty) return {'uid': '', 'email': ''};
      final d = qs.docs.first;
      final email = (d.data()['email'] as String?) ?? '';
      return {'uid': d.id, 'email': email};
    } on FirebaseException {
      return {'uid': '', 'email': ''};
    }
  }

  Future<int> _currentUserNumericId() async {
    final uid = _uidOrThrow();
    final snap = await _firestore.collection('users').doc(uid).get();
    return (snap.data()?['id'] as num?)?.toInt() ?? 0;
  }

  Future<String> _currentUserRole() async {
    final uid = _uidOrThrow();
    final snap = await _firestore.collection('users').doc(uid).get();
    return (snap.data()?['role'] as String?) ?? 'standard';
  }

  @override
  Future<int> addAppointment(AppointmentModel appointmentModel) async {
    try {
      final uid = _uidOrThrow();
      final id = appointmentModel.id ?? DateTime.now().millisecondsSinceEpoch;
      final numericUserId = appointmentModel.userId == 0
          ? await _currentUserNumericId()
          : appointmentModel.userId;
      // enrich with trainer uid/email for robust trainer-side querying
      final trainerInfo =
          await _trainerUidEmailByNumericId(appointmentModel.trainerId);
      await _col.doc(id.toString()).set({
        'id': id,
        'ownerUid': uid,
        'date': Timestamp.fromDate(appointmentModel.date),
        'startTime': appointmentModel.startTime,
        'endTime': appointmentModel.endTime,
        'trainerId': appointmentModel.trainerId,
        'trainerUid': trainerInfo['uid'] ?? '',
        'trainerEmail': trainerInfo['email'] ?? '',
        'userId': numericUserId,
        'remark': appointmentModel.remark,
        'status': appointmentModel.status.isEmpty
            ? 'pending'
            : appointmentModel.status,
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
      if (appointmentModel.id == null) throw ServerException();
      final docRef = _col.doc(appointmentModel.id!.toString());
      // keep trainer uid/email in sync in case trainer changes
      final trainerInfo =
          await _trainerUidEmailByNumericId(appointmentModel.trainerId);
      await docRef.update({
        'date': Timestamp.fromDate(appointmentModel.date),
        'startTime': appointmentModel.startTime,
        'endTime': appointmentModel.endTime,
        'trainerId': appointmentModel.trainerId,
        'trainerUid': trainerInfo['uid'] ?? '',
        'trainerEmail': trainerInfo['email'] ?? '',
        'userId': appointmentModel.userId,
        'remark': appointmentModel.remark,
        'status': appointmentModel.status,
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
      _uidOrThrow();
      await _col.doc(appointmentId.toString()).delete();
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final uid = _uidOrThrow();
      final role = await _currentUserRole();

      if (role == 'admin') {
        // Admin: view all appointments
        QuerySnapshot<Map<String, dynamic>> qs;
        try {
          qs = await _col.orderBy('date', descending: true).get();
        } on FirebaseException catch (e) {
          if (e.code == 'failed-precondition' || e.code == 'permission-denied') {
            qs = await _col.get();
          } else {
            rethrow;
          }
        }
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
            status: (data['status'] as String?) ?? 'pending',
          );
        }).toList();
      } else if (role == 'trainer') {
        // Trainer: fetch appointments assigned to me from top-level collection
        final trainerNumericId = await _currentUserNumericId();
        final String myUid = uid;

        Future<QuerySnapshot<Map<String, dynamic>>> byUid() async {
          return await _col.where('trainerUid', isEqualTo: myUid).get();
        }

        Future<QuerySnapshot<Map<String, dynamic>>> byNumericId() async {
          return await _col.where('trainerId', isEqualTo: trainerNumericId).get();
        }

        List<QueryDocumentSnapshot<Map<String, dynamic>>> docsByUid =
            <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        List<QueryDocumentSnapshot<Map<String, dynamic>>> docsById =
            <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        try {
          docsByUid = (await byUid()).docs;
        } catch (e) {
          docsByUid = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        }
        try {
          docsById = trainerNumericId == 0
              ? <QueryDocumentSnapshot<Map<String, dynamic>>>[]
              : (await byNumericId()).docs;
        } catch (e) {
          docsById = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        }

        final byId = <int, Map<String, dynamic>>{};
        void addAll(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
          for (final d in docs) {
            final m = d.data();
            final aid = (m['id'] as num?)?.toInt();
            if (aid != null) byId[aid] = m;
          }
        }
        addAll(docsByUid);
        addAll(docsById);

        final list = byId.values.toList()
          ..sort((a, b) {
            final ad = a['date'];
            final bd = b['date'];
            DateTime toDate(dynamic ts) => ts is Timestamp
                ? ts.toDate()
                : DateTime.tryParse((ts ?? '').toString()) ?? DateTime(1970);
            return toDate(bd).compareTo(toDate(ad));
          });

        return list.map((data) {
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
            status: (data['status'] as String?) ?? 'pending',
          );
        }).toList();
      } else {
        // Standard user: appointments where I am the owner
        QuerySnapshot<Map<String, dynamic>> qs;
        try {
          qs = await _col
              .where('ownerUid', isEqualTo: uid)
              .orderBy('date', descending: true)
              .get();
        } on FirebaseException catch (e) {
          if (e.code == 'failed-precondition' || e.code == 'permission-denied') {
            // Fallback without orderBy or return empty on permission issues
            try {
              qs = await _col.where('ownerUid', isEqualTo: uid).get();
            } catch (_) {
              return <AppointmentModel>[];
            }
          } else {
            rethrow;
          }
        }

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
            status: (data['status'] as String?) ?? 'pending',
          );
        }).toList();
      }
    } on FirebaseException {
      throw ServerException();
    }
  }
}
