import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/models/login_credentials_model.dart';
import 'package:fitness_app/core/models/user_model.dart';

class FirebaseAuthDataSourceImpl implements AuthRemoteDataSource {
  fb.FirebaseAuth get _auth => fb.FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCol =>
      _firestore.collection('users');
  CollectionReference<Map<String, dynamic>> get _profilesCol =>
      _firestore.collection('profiles');

  bool _isAllowedEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final parts = email.split('@');
    if (parts.length != 2) return false;
    final domain = parts[1].toLowerCase();
    return domain == 'wlv.ac.uk' || domain.endsWith('.wlv.ac.uk');
  }

  @override
  Future<UserModel> login(LoginCredentialsModel loginModel) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: loginModel.email,
        password: loginModel.password,
      );
      final user = cred.user;
      if (user == null) throw LoginException();

      // Enforce institutional email domain restriction
      final signInEmail = user.email ?? loginModel.email;
      if (!_isAllowedEmail(signInEmail)) {
        await _auth.signOut();
        throw DomainRestrictedException();
      }

      final userDocRef = _usersCol.doc(user.uid);
      final userSnap = await userDocRef.get();
      if (!userSnap.exists) {
        final numericId = DateTime.now().millisecondsSinceEpoch;
        await userDocRef.set({
          'id': numericId,
          'email': user.email ?? loginModel.email,
          'role': 'standard',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        final dataNow = userSnap.data() ?? {};
        if (dataNow['id'] == null) {
          await userDocRef.update({'id': DateTime.now().millisecondsSinceEpoch});
        }
        await userDocRef.update({'updatedAt': FieldValue.serverTimestamp()});
      }

      // Ensure profile document exists
      final profileRef = _profilesCol.doc(user.uid);
      final profSnap = await profileRef.get();
      if (!profSnap.exists) {
        await profileRef.set({
          'id': user.uid,
          'name': user.displayName ?? '',
          'age': 0,
          'gender': '',
          'height': 0,
          'weight': 0,
          'goal': '',
          'photoUrl': '',
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }

      final udata = (await userDocRef.get()).data() ?? {};
      return UserModel(
        id: (udata['id'] as num?)?.toInt() ?? 0,
        name: (udata['name'] as String?) ?? (user.displayName ?? ''),
        email: (udata['email'] as String?) ?? user.email ?? loginModel.email,
        password: loginModel.password,
        institutionEmail: (udata['institutionEmail'] as String?) ?? '',
        gender: (udata['gender'] as String?) ?? '',
        age: (udata['age'] as num?)?.toInt() ?? 0,
        role: (udata['role'] as String?) ?? 'standard',
      );
    } on fb.FirebaseAuthException {
      throw LoginException();
    } on FirebaseException {
      throw LoginException();
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      fb.UserCredential cred;
      if (kIsWeb) {
        final provider = fb.GoogleAuthProvider();
        provider.addScope('email');
        cred = await _auth.signInWithPopup(provider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          throw LoginException();
        }
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final fb.OAuthCredential credential = fb.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        cred = await _auth.signInWithCredential(credential);
      }

      final user = cred.user;
      if (user == null) throw LoginException();

      // Enforce institutional email domain restriction
      if (!_isAllowedEmail(user.email)) {
        await _auth.signOut();
        throw DomainRestrictedException();
      }

      final userDocRef = _usersCol.doc(user.uid);
      final userSnap = await userDocRef.get();
      if (!userSnap.exists) {
        final numericId = DateTime.now().millisecondsSinceEpoch;
        await userDocRef.set({
          'id': numericId,
          'email': user.email ?? '',
          'role': 'standard',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await userDocRef.update({'updatedAt': FieldValue.serverTimestamp()});
      }
      // Ensure profile document exists
      final profileRef = _profilesCol.doc(user.uid);
      final profSnap = await profileRef.get();
      if (!profSnap.exists) {
        await profileRef.set({
          'id': user.uid,
          'name': user.displayName ?? '',
          'age': 0,
          'gender': '',
          'height': 0,
          'weight': 0,
          'goal': '',
          'photoUrl': '',
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
      final udata = (await userDocRef.get()).data() ?? {};
      return UserModel(
        id: (udata['id'] as num?)?.toInt() ?? 0,
        name: (udata['name'] as String?) ?? (user.displayName ?? ''),
        email: (udata['email'] as String?) ?? user.email ?? '',
        password: '',
        institutionEmail: (udata['institutionEmail'] as String?) ?? '',
        gender: (udata['gender'] as String?) ?? '',
        age: (udata['age'] as num?)?.toInt() ?? 0,
        role: (udata['role'] as String?) ?? 'standard',
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
      // Enforce institutional email domain restriction on registration
      if (!_isAllowedEmail(userModel.email)) {
        throw DomainRestrictedException();
      }
      final cred = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      final uid = cred.user!.uid;
      final numericId = DateTime.now().millisecondsSinceEpoch;
      await _usersCol.doc(uid).set({
        'id': numericId,
        'email': userModel.email,
        'role': userModel.role,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await _profilesCol.doc(uid).set({
        'id': uid,
        'name': '',
        'age': 0,
        'gender': '',
        'height': 0,
        'weight': 0,
        'goal': '',
        'photoUrl': '',
        'lastUpdated': FieldValue.serverTimestamp(),
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
