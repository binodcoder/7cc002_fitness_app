import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<String?> currentAccountId();
  Future<UserProfileModel?> getCurrent();
  Future<int> upsert(UserProfileModel model);
}

class FirebaseProfileRemoteDataSource implements ProfileRemoteDataSource {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  fb.FirebaseAuth get _auth => fb.FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('profiles');

  @override
  Future<String?> currentAccountId() async => _auth.currentUser?.uid;

  @override
  Future<UserProfileModel?> getCurrent() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return null;
      final doc = await _col.doc(uid).get();
      if (!doc.exists) return null;
      final data = doc.data() ?? {};
      // Ensure id
      data['id'] = uid;
      // Convert Timestamp to ISO string
      final ts = data['lastUpdated'];
      if (ts is Timestamp) {
        data['lastUpdated'] = ts.toDate().toIso8601String();
      }
      return UserProfileModel.fromJson(data);
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> upsert(UserProfileModel model) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw ServerException();
      await _col.doc(uid).set({
        'id': uid,
        'name': model.name,
        'age': model.age,
        'gender': model.gender,
        'height': model.height,
        'weight': model.weight,
        'goal': model.goal,
        'photoUrl': model.photoUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }
}
