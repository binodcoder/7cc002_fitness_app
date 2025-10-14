import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/walk/data/data_sources/walks_remote_data_source.dart';
import 'package:fitness_app/features/walk/data/models/walk_model.dart';
import 'package:fitness_app/features/walk/data/models/walk_participant_model.dart';

class FirebaseWalkRemoteDataSource implements WalkRemoteDataSource {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  fb.FirebaseAuth get _auth => fb.FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('walks');

  Future<int> _currentUserNumericId() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw ServerException();
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final id = (userDoc.data()?['id'] as num?)?.toInt();
    return id ?? DateTime.now().millisecondsSinceEpoch;
  }

  Map<String, dynamic> _participantMapFromModel(ParticipantModel p) => {
        'id': p.id,
        'name': p.name,
        'email': p.email,
        'password': p.password,
        'institutionEmail': p.institutionEmail,
        'gender': p.gender,
        'age': p.age,
        'role': p.role,
      };

  ParticipantModel _participantModelFromMap(Map<String, dynamic> m) {
    // Ensure required keys exist to satisfy model constructor
    final data = {
      'id': (m['id'] as num?)?.toInt() ?? 0,
      'name': (m['name'] ?? '').toString(),
      'email': (m['email'] ?? '').toString(),
      'password': (m['password'] ?? '').toString(),
      'institutionEmail': (m['institutionEmail'] ?? '').toString(),
      'gender': (m['gender'] ?? '').toString(),
      'age': (m['age'] as num?)?.toInt() ?? 0,
      'role': (m['role'] ?? '').toString(),
    };
    return ParticipantModel.fromJson(data);
  }

  @override
  Future<List<WalkModel>> getWalks() async {
    try {
      final qs = await _col.orderBy('date', descending: true).get();
      return qs.docs.map((d) {
        final data = d.data();
        final ts = data['date'];
        final date = ts is Timestamp
            ? ts.toDate()
            : DateTime.tryParse((ts ?? '').toString()) ?? DateTime.now();
        final parts = (data['participants'] as List?) ?? const [];
        final participants = parts
            .whereType<dynamic>()
            .map((e) => _participantModelFromMap(
                (e as Map?)?.cast<String, dynamic>() ?? const {}))
            .toList();
        return WalkModel(
          id: (data['id'] as num?)?.toInt(),
          proposerId: (data['proposerId'] as num?)?.toInt() ?? 0,
          routeData: (data['routeData'] as String?) ?? '',
          date: date,
          startTime: (data['startTime'] as String?) ?? '',
          startLocation: (data['startLocation'] as String?) ?? '',
          participants: participants,
        );
      }).toList();
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> addWalk(WalkModel walkModel) async {
    try {
      final id = walkModel.id ?? DateTime.now().millisecondsSinceEpoch;
      final proposerId = walkModel.proposerId != 0
          ? walkModel.proposerId
          : await _currentUserNumericId();
      await _col.add({
        'id': id,
        'ownerUid': _auth.currentUser?.uid,
        'proposerId': proposerId,
        'routeData': walkModel.routeData,
        'date': Timestamp.fromDate(walkModel.date),
        'startTime': walkModel.startTime,
        'startLocation': walkModel.startLocation,
        'participants': walkModel.participants
            .map((p) => _participantMapFromModel(p as ParticipantModel))
            .toList(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> updateWalk(WalkModel walkModel) async {
    try {
      if (walkModel.id == null) throw ServerException();
      final qs =
          await _col.where('id', isEqualTo: walkModel.id).limit(1).get();
      if (qs.docs.isEmpty) throw ServerException();
      await qs.docs.first.reference.update({
        'routeData': walkModel.routeData,
        'date': Timestamp.fromDate(walkModel.date),
        'startTime': walkModel.startTime,
        'startLocation': walkModel.startLocation,
        'participants': walkModel.participants
            .map((p) => _participantMapFromModel(p as ParticipantModel))
            .toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> deleteWalk(int walkId) async {
    try {
      final qs = await _col.where('id', isEqualTo: walkId).limit(1).get();
      if (qs.docs.isEmpty) throw ServerException();
      await qs.docs.first.reference.delete();
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> joinWalk(WalkParticipantModel walkParticipantModel) async {
    try {
      // Resolve participant id if not provided
      final participantId = walkParticipantModel.userId == 0
          ? await _currentUserNumericId()
          : walkParticipantModel.userId;
      final qs = await _col
          .where('id', isEqualTo: walkParticipantModel.walkId)
          .limit(1)
          .get();
      if (qs.docs.isEmpty) throw ServerException();
      final ref = qs.docs.first.reference;
      final snap = await ref.get();
      final current = (snap.data()?['participants'] as List?) ?? const [];
      final already = current.any((e) =>
          (e is Map && (e['id'] as num?)?.toInt() == participantId));
      if (already) return 1;

      // Try enrich participant from users collection
      Map<String, dynamic> p = {
        'id': participantId,
        'name': '',
        'email': '',
        'password': '',
        'institutionEmail': '',
        'gender': '',
        'age': 0,
        'role': 'standard',
      };
      final userQs = await _firestore
          .collection('users')
          .where('id', isEqualTo: participantId)
          .limit(1)
          .get();
      if (userQs.docs.isNotEmpty) {
        final doc = userQs.docs.first;
        final u = doc.data();
        String name = (u['name'] ?? '').toString();
        String gender = (u['gender'] ?? '').toString();
        int age = (u['age'] as num?)?.toInt() ?? 0;
        try {
          final profile = await _firestore.collection('profiles').doc(doc.id).get();
          final pdata = profile.data();
          if (pdata != null) {
            name = (pdata['name'] ?? name).toString();
            gender = (pdata['gender'] ?? gender).toString();
            age = (pdata['age'] as num?)?.toInt() ?? age;
          }
        } catch (_) {}
        p = {
          'id': (u['id'] as num?)?.toInt() ?? walkParticipantModel.userId,
          'name': name,
          'email': (u['email'] ?? '').toString(),
          'password': '',
          'institutionEmail': (u['institutionEmail'] ?? '').toString(),
          'gender': gender,
          'age': age,
          'role': (u['role'] ?? '').toString(),
        };
      }
      await ref.update({
        'participants': FieldValue.arrayUnion([p]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> leaveWalk(WalkParticipantModel walkParticipantModel) async {
    try {
      final participantId = walkParticipantModel.userId == 0
          ? await _currentUserNumericId()
          : walkParticipantModel.userId;
      final qs = await _col
          .where('id', isEqualTo: walkParticipantModel.walkId)
          .limit(1)
          .get();
      if (qs.docs.isEmpty) throw ServerException();
      final ref = qs.docs.first.reference;
      final data = (await ref.get()).data();
      final parts = (data?['participants'] as List?) ?? const [];
      final toRemove = parts.firstWhere(
        (e) => e is Map && (e['id'] as num?)?.toInt() == participantId,
        orElse: () => null,
      );
      if (toRemove == null) return 1;
      await ref.update({
        'participants': FieldValue.arrayRemove([toRemove]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }
}
