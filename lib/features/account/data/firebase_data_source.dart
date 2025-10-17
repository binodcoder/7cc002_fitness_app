import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/core/models/user_model.dart';

class FirebaseDataSource {
  FirebaseDataSource({required this.firestore});
  final FirebaseFirestore firestore;
  Stream<List<UserModel>> getUsers() {
    return firestore.collection('users').orderBy('email').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList());
  }

  Future<void> updateUser(int userId, String role) {
    return firestore
        .collection('users')
        .doc(userId.toString())
        .update({'role': role});
  }
}
