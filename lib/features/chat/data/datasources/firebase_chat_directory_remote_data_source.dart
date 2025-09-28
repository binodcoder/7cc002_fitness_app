import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart' as entity;

import 'chat_directory_remote_data_source.dart';

class FirebaseChatDirectoryRemoteDataSource
    implements ChatDirectoryRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<entity.User>> getUsers() async {
    final qs = await _firestore.collection('users').get();
    return qs.docs.map((d) {
      final data = d.data();
      return entity.User(
        id: (data['id'] as num?)?.toInt(),
        age: (data['age'] as num?)?.toInt() ?? 0,
        email: (data['email'] as String?) ?? '',
        gender: (data['gender'] as String?) ?? '',
        institutionEmail: (data['institutionEmail'] as String?) ?? '',
        name: (data['name'] as String?) ?? '',
        password: '',
        role: (data['role'] as String?) ?? 'standard',
      );
    }).toList();
  }
}
