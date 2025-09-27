import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/walk/domain/repositories/walk_repositories.dart';
import 'package:fitness_app/features/walk/domain/usecases/get_walks.dart';
import 'package:fitness_app/features/walk/domain/usecases/add_walk.dart';
import 'package:fitness_app/features/walk/domain/usecases/update_walk.dart';
import 'package:fitness_app/features/walk/domain/usecases/delete_walk.dart';
import 'package:fitness_app/features/walk/domain/entities/walk_media.dart';
import 'package:fitness_app/features/walk/domain/repositories/walk_media_repositories.dart';
import 'package:fitness_app/features/walk/domain/usecases/get_walk_media.dart';
import 'package:fitness_app/features/walk/domain/usecases/get_walk_media_by_walk_id.dart';
import 'package:fitness_app/features/walk/domain/usecases/add_walk_media.dart';
import 'package:fitness_app/features/walk/domain/usecases/update_walk_media.dart';
import 'package:fitness_app/features/walk/domain/usecases/delete_walk_media.dart';
import 'package:fitness_app/features/walk/domain/usecases/join_walk.dart';
import 'package:fitness_app/features/walk/domain/usecases/leave_walk.dart';

class MockWalkRepo extends Mock implements WalkRepository {}
class MockWalkMediaRepo extends Mock implements WalkMediaRepository {}

void main() {
  final walkRepo = MockWalkRepo();
  final mediaRepo = MockWalkMediaRepo();

  final getWalksUse = GetWalks(walkRepo);
  final addWalkUse = AddWalk(walkRepo);
  final updateWalkUse = UpdateWalk(walkRepo);
  final deleteWalkUse = DeleteWalk(walkRepo);
  final joinWalkUse = JoinWalk(walkRepo);
  final leaveWalkUse = LeaveWalk(walkRepo);

  final getMediaUse = GetWalkMedia(mediaRepo);
  final getMediaByWalkUse = GetWalkMediaByWalkId(mediaRepo);
  final addMediaUse = AddWalkMedia(mediaRepo);
  final updateMediaUse = UpdateWalkMedia(mediaRepo);
  final deleteMediaUse = DeleteWalkMedia(mediaRepo);

  final w = Walk(
    id: 1,
    proposerId: 2,
    routeData: 'encoded-polyline',
    date: DateTime(2025, 1, 1),
    startTime: '09:00',
    startLocation: 'Campus',
  );
  const wm = WalkMedia(id: 1, walkId: 2, userId: 3, mediaUrl: 'u');

  test('walk usecases', () async {
    when(walkRepo.getWalks()).thenAnswer((_) async => const Right(<Walk>[]));
    when(walkRepo.addWalk(w)).thenAnswer((_) async => const Right(1));
    when(walkRepo.updateWalk(w)).thenAnswer((_) async => const Right(1));
    when(walkRepo.deleteWalk(1)).thenAnswer((_) async => const Right(1));
    when(walkRepo.joinWalk(const WalkParticipant(userId: 1, walkId: 1))).thenAnswer((_) async => const Right(1));
    when(walkRepo.leaveWalk(const WalkParticipant(userId: 1, walkId: 1))).thenAnswer((_) async => const Right(1));

    expect(await getWalksUse(NoParams()), const Right(<Walk>[]));
    expect(await addWalkUse(w), const Right(1));
    expect(await updateWalkUse(w), const Right(1));
    expect(await deleteWalkUse(1), const Right(1));
    expect(await joinWalkUse(const WalkParticipant(userId: 1, walkId: 1)), const Right(1));
    expect(await leaveWalkUse(const WalkParticipant(userId: 1, walkId: 1)), const Right(1));
  });

  test('walk media usecases', () async {
    when(mediaRepo.getWalkMedia()).thenAnswer((_) async => const Right(<WalkMedia>[]));
    when(mediaRepo.getWalkMediaByWalkId(2)).thenAnswer((_) async => const Right(<WalkMedia>[]));
    when(mediaRepo.addWalkMedia(wm)).thenAnswer((_) async => const Right(1));
    when(mediaRepo.updateWalkMedia(wm)).thenAnswer((_) async => const Right(1));
    when(mediaRepo.deleteWalkMedia(1)).thenAnswer((_) async => const Right(1));

    expect(await getMediaUse(NoParams()), const Right(<WalkMedia>[]));
    expect(await getMediaByWalkUse(2), const Right(<WalkMedia>[]));
    expect(await addMediaUse(wm), const Right(1));
    expect(await updateMediaUse(wm), const Right(1));
    expect(await deleteMediaUse(1), const Right(1));
  });
}
