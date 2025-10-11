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
      final trainers = qs.docs.map((d) {
        final data = d.data();
        return TrainerModel(
          id: (data['id'] as num?)?.toInt() ?? 0,
          name: (data['name'] as String?) ?? '',
          email: (data['email'] as String?) ?? '',
          password: '',
          institutionEmail: (data['institutionEmail'] as String?) ?? '',
          gender: (data['gender'] as String?) ?? '',
          age: (data['age'] as num?)?.toInt() ?? 0,
          role: (data['role'] as String?) ?? 'trainer',
        );
      }).toList();

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
