import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/appointment/data/datasources/sync_remote_data_source.dart';
import 'package:fitness_app/features/appointment/data/models/sync_data_model.dart';

class FirebaseSyncRemoteDataSource implements SyncRemoteDataSource {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  @override
  Future<SyncModel> sync(String email) async {
    try {
      final qs = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'trainer')
          .get();
      final trainers = <TrainerModel>[];
      for (final d in qs.docs) {
        final data = d.data();
        final uid = d.id;
        String name = '';
        String gender = '';
        int age = 0;
        try {
          final prof = await _firestore.collection('profiles').doc(uid).get();
          final p = prof.data();
          if (p != null) {
            name = (p['name'] as String?) ?? '';
            gender = (p['gender'] as String?) ?? '';
            age = (p['age'] as num?)?.toInt() ?? 0;
          }
        } catch (_) {}
        trainers.add(TrainerModel(
          id: (data['id'] as num?)?.toInt() ?? 0,
          name: name,
          email: (data['email'] as String?) ?? '',
          password: '',
          institutionEmail: (data['institutionEmail'] as String?) ?? '',
          gender: gender,
          age: age,
          role: (data['role'] as String?) ?? 'trainer',
        ));
      }

      const company = CompanyModel(
        id: 1,
        name: 'Fitness Company',
        email: 'support@fitness.app',
        phone: '',
        address: '',
      );
      return SyncModel(
        data: SyncDataModel(
          trainers: trainers,
          company: company,
          message: 'ok',
        ),
      );
    } on FirebaseException {
      throw ServerException();
    }
  }
}
