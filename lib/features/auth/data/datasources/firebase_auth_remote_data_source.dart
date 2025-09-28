import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:fitness_app/features/auth/data/models/login_credentials_model.dart';
import 'package:fitness_app/features/auth/data/models/user_model.dart';

class FirebaseAuthRemoteDataSourceImpl implements AuthDataSource {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCol =>
      _firestore.collection('users');

  @override
  Future<UserModel> login(LoginCredentialsModel loginModel) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: loginModel.email,
        password: loginModel.password,
      );
      final user = cred.user;
      if (user == null) throw LoginException();

      final docRef = _usersCol.doc(user.uid);
      final snap = await docRef.get();
      if (!snap.exists) {
        final numericId = DateTime.now().millisecondsSinceEpoch;
        await docRef.set({
          'id': numericId,
          'email': user.email ?? loginModel.email,
          'name': '',
          'age': 0,
          'gender': '',
          'institutionEmail': '',
          'role': 'standard',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        final dataNow = snap.data() ?? {};
        if (dataNow['id'] == null) {
          await docRef.update({'id': DateTime.now().millisecondsSinceEpoch});
        }
        await docRef.update({'updatedAt': FieldValue.serverTimestamp()});
      }
      final data = (await docRef.get()).data() ?? {};
      return UserModel(
        id: (data['id'] as num?)?.toInt(),
        email: (data['email'] as String?) ?? user.email ?? '',
        name: (data['name'] as String?) ?? '',
        password: loginModel.password,
        age: (data['age'] as num?)?.toInt() ?? 0,
        gender: (data['gender'] as String?) ?? '',
        institutionEmail: (data['institutionEmail'] as String?) ?? '',
        role: (data['role'] as String?) ?? 'standard',
      );
    } on fb.FirebaseAuthException {
      throw LoginException();
    } on FirebaseException {
      throw LoginException();
    }
  }

  @override
  Future<int> addUser(UserModel userModel) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      final uid = cred.user!.uid;
      final numericId = DateTime.now().millisecondsSinceEpoch;
      await _usersCol.doc(uid).set({
        'id': numericId,
        'email': userModel.email,
        'name': userModel.name,
        'age': userModel.age,
        'gender': userModel.gender,
        'institutionEmail': userModel.institutionEmail,
        'role': userModel.role,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return 1;
    } on fb.FirebaseAuthException {
      throw ServerException();
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> updateUser(UserModel userModel) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw ServerException();
      await _usersCol.doc(uid).set({
        'email': userModel.email,
        'name': userModel.name,
        'age': userModel.age,
        'gender': userModel.gender,
        'institutionEmail': userModel.institutionEmail,
        'role': userModel.role,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> deleteUser(int userId) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw ServerException();
      await _usersCol.doc(uid).delete();
      return 1;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<int> signOut() async {
    await _auth.signOut();
    return 1;
  }

  @override
  Future<int> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 1;
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 1;
      }
      throw ServerException();
    } on FirebaseException {
      throw ServerException();
    }
  }
}
