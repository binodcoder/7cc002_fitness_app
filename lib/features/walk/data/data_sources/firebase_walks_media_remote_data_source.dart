import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/walk/data/data_sources/walks_media_remote_data_source.dart';
import 'package:fitness_app/features/walk/data/models/walk_media_model.dart';

class FirebaseWalkMediaRemoteDataSource implements WalkMediaRemoteDataSource {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  fb.FirebaseAuth get _auth => fb.FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('walk_media');

  Future<int> _currentUserNumericId() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return DateTime.now().millisecondsSinceEpoch;
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final id = (userDoc.data()?['id'] as num?)?.toInt();
    return id ?? DateTime.now().millisecondsSinceEpoch;
  }

  WalkMediaModel _fromDoc(
      DocumentSnapshot<Map<String, dynamic>> doc, Map<String, dynamic> data) {
    return WalkMediaModel(
      id: (data['id'] as num?)?.toInt(),
      walkId: (data['walkId'] as num?)?.toInt() ?? 0,
      userId: (data['userId'] as num?)?.toInt() ?? 0,
      mediaUrl: (data['mediaUrl'] as String?) ?? '',
    );
  }

  @override
  Future<List<WalkMediaModel>> getWalkMedias() async {
    try {
      final qs = await _col.orderBy('createdAt', descending: true).get();
      return qs.docs.map((d) => _fromDoc(d, d.data())).toList();
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<List<WalkMediaModel>> getWalkMediaByWalkId(int walkId) async {
    try {
      // Avoid requiring a composite index: filter by walkId and sort client-side if needed
      final qs = await _col.where('walkId', isEqualTo: walkId).get();
      return qs.docs.map((d) => _fromDoc(d, d.data())).toList();
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> addWalkMedia(WalkMediaModel walkMediaModel) async {
    try {
      final id = walkMediaModel.id ?? DateTime.now().millisecondsSinceEpoch;
      final userId = walkMediaModel.userId != 0
          ? walkMediaModel.userId
          : await _currentUserNumericId();
      await _col.add({
        'id': id,
        'walkId': walkMediaModel.walkId,
        'userId': userId,
        'mediaUrl': walkMediaModel.mediaUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> updateWalkMedia(WalkMediaModel walkMediaModel) async {
    try {
      if (walkMediaModel.id == null) throw ServerException();
      final qs = await _col.where('id', isEqualTo: walkMediaModel.id).limit(1).get();
      if (qs.docs.isEmpty) throw ServerException();
      await qs.docs.first.reference.update({
        'walkId': walkMediaModel.walkId,
        'userId': walkMediaModel.userId,
        'mediaUrl': walkMediaModel.mediaUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> deleteWalkMedia(int id) async {
    try {
      final qs = await _col.where('id', isEqualTo: id).limit(1).get();
      if (qs.docs.isEmpty) return 1;
      await qs.docs.first.reference.delete();
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }
}
