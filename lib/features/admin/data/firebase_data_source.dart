import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/features/auth/data/models/user_model.dart';

class FirebaseDataSource {
  Stream<List<UserModel>> getUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('email')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList());
  }

  Future<void> updateUser(int userId, String role) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId.toString())
        .update({'role': role});
  }
}
