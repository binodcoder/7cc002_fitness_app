import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/appointment/domain/repositories/sync_repositories.dart';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart';
import 'package:fitness_app/features/appointment/domain/usecases/sync.dart';

class MockSyncRepository extends Mock implements SyncRepository {}

void main() {
  final repo = MockSyncRepository();
  final use = Sync(repo);
  const tEntity = SyncEntity(
    data: SyncDataEntity(
      trainers: [],
      company: CompanyEntity(id: 1, name: 'c', email: 'e', phone: 'p', address: 'a'),
      message: 'ok',
    ),
  );
  test('sync forwards to repository', () async {
    when(repo.sync('e')).thenAnswer((_) async => const Right(tEntity));
    expect(await use('e'), const Right(tEntity));
    verify(repo.sync('e'));
  });
}
