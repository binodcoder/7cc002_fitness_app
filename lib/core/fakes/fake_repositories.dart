import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart'
    as sync_entity;
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/features/appointment/domain/repositories/appointment_repositories.dart';
import 'package:fitness_app/features/appointment/domain/repositories/sync_repositories.dart';
import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';
import 'package:fitness_app/features/live_training/domain/repositories/live_training_repositories.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';
import 'package:fitness_app/features/routine/domain/repositories/routine_repositories.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/features/walk/domain/repositories/walk_repositories.dart';
import 'package:fitness_app/features/walk/domain/entities/walk_media.dart';
import 'package:fitness_app/features/walk/domain/repositories/walk_media_repositories.dart';

class _InMemoryDB {
  static final _InMemoryDB _instance = _InMemoryDB._();
  _InMemoryDB._();
  factory _InMemoryDB() => _instance;

  final List<Routine> routines = [
    const Routine(
        id: 1,
        name: 'Full Body Beginner',
        description: 'A simple full body routine',
        duration: 30,
        source: 'App'),
    const Routine(
        id: 2,
        name: 'Upper Body Blast',
        description: 'Focus on arms and chest',
        duration: 45,
        source: 'App'),
  ];

  final List<Walk> walks = [
    Walk(
        id: 1,
        proposerId: 1,
        routeData: 'City Park Loop',
        date: DateTime.now(),
        startTime: '09:00',
        startLocation: 'Main Gate',
        participants: const []),
  ];

  final List<LiveTraining> liveTrainings = [
    LiveTraining(
        trainerId: 1,
        title: 'Morning Yoga',
        description: 'Start your day right',
        trainingDate: DateTime.now(),
        startTime: '07:00',
        endTime: '08:00'),
  ];

  final List<Appointment> appointments = [
    Appointment(
        date: DateTime.now(),
        startTime: '10:00:00',
        endTime: '11:00:00',
        trainerId: 1,
        userId: 1,
        remark: 'First session'),
  ];

  final List<WalkMedia> walkMedia = [
    const WalkMedia(
        id: 1, walkId: 1, userId: 1, mediaUrl: 'media/sample_photo_1.png'),
    const WalkMedia(
        id: 2, walkId: 1, userId: 2, mediaUrl: 'media/sample_photo_2.png'),
  ];
}

class FakeRoutineRepository implements RoutineRepository {
  final _db = _InMemoryDB();
  @override
  Future<Either<Failure, List<Routine>>>? getRoutines() async =>
      Right(_db.routines);

  @override
  Future<Either<Failure, int>>? addRoutine(Routine routine) async {
    final id = (_db.routines
            .map((e) => e.id ?? 0)
            .fold<int>(0, (p, c) => c > p ? c : p)) +
        1;
    _db.routines.add(Routine(
        id: id,
        name: routine.name,
        description: routine.description,
        duration: routine.duration,
        source: routine.source));
    return const Right(1);
  }

  @override
  Future<Either<Failure, int>>? updateRoutine(Routine routine) async {
    final index = _db.routines.indexWhere((r) => r.id == routine.id);
    if (index >= 0) _db.routines[index] = routine;
    return const Right(1);
  }

  @override
  Future<Either<Failure, int>>? deleteRoutine(int routineId) async {
    _db.routines.removeWhere((r) => r.id == routineId);
    return const Right(1);
  }
}

class FakeWalkRepository implements WalkRepository {
  final _db = _InMemoryDB();

  @override
  Future<Either<Failure, List<Walk>>>? getWalks() async => Right(_db.walks);

  @override
  Future<Either<Failure, int>>? addWalk(Walk walk) async {
    final id = (_db.walks
            .map((e) => e.id ?? 0)
            .fold<int>(0, (p, c) => c > p ? c : p)) +
        1;
    _db.walks.add(Walk(
        id: id,
        proposerId: walk.proposerId,
        routeData: walk.routeData,
        date: walk.date,
        startTime: walk.startTime,
        startLocation: walk.startLocation,
        participants: walk.participants));
    return const Right(1);
  }

  @override
  Future<Either<Failure, int>>? updateWalk(Walk walk) async {
    final index = _db.walks.indexWhere((w) => w.id == walk.id);
    if (index >= 0) _db.walks[index] = walk;
    return const Right(1);
  }

  @override
  Future<Either<Failure, int>>? deleteWalk(int id) async {
    _db.walks.removeWhere((w) => w.id == id);
    return const Right(1);
  }

  @override
  Future<Either<Failure, int>>? joinWalk(WalkParticipant p) async {
    final walk = _db.walks.firstWhere((w) => w.id == p.walkId);
    // Convert WalkParticipant to Participant for display purposes
    walk.participants.add(Participant(
      id: p.userId,
      name: 'User ${p.userId}',
      email: 'user${p.userId}@example.com',
      password: '',
      institutionEmail: '',
      gender: '-',
      age: 0,
      role: 'standard',
    ));
    return const Right(1);
  }

  @override
  Future<Either<Failure, int>>? leaveWalk(WalkParticipant p) async {
    final walk = _db.walks.firstWhere((w) => w.id == p.walkId);
    walk.participants.removeWhere((e) => e.id == p.userId);
    return const Right(1);
  }
}

class FakeLiveTrainingRepository implements LiveTrainingRepository {
  final _db = _InMemoryDB();
  @override
  Future<Either<Failure, List<LiveTraining>>>? getLiveTrainings() async =>
      Right(_db.liveTrainings);

  @override
  Future<Either<Failure, int>>? addLiveTraining(LiveTraining lt) async {
    _db.liveTrainings.add(lt);
    return const Right(1);
  }

  @override
  Future<Either<Failure, int>>? updateLiveTraining(LiveTraining lt) async =>
      const Right(1);

  @override
  Future<Either<Failure, int>>? deleteLiveTraining(int id) async =>
      const Right(1);
}

class FakeAppointmentRepositories implements AppointmentRepositories {
  final _db = _InMemoryDB();
  @override
  Future<Either<Failure, List<Appointment>>>? getAppointments() async =>
      Right(_db.appointments);

  @override
  Future<Either<Failure, int>>? addAppointment(Appointment a) async {
    _db.appointments.add(a);
    return const Right(1);
  }

  @override
  Future<Either<Failure, int>>? updateAppointment(Appointment a) async =>
      const Right(1);

  @override
  Future<Either<Failure, int>>? deleteAppointment(int id) async =>
      const Right(1);
}

class FakeWalkMediaRepository implements WalkMediaRepository {
  final _db = _InMemoryDB();
  @override
  Future<Either<Failure, List<WalkMedia>>>? getWalkMedia() async =>
      Right(_db.walkMedia);

  @override
  Future<Either<Failure, List<WalkMedia>>>? getWalkMediaByWalkId(
          int walkId) async =>
      Right(_db.walkMedia.where((w) => w.walkId == walkId).toList());

  @override
  Future<Either<Failure, int>>? addWalkMedia(WalkMedia wm) async {
    _db.walkMedia.add(wm);
    return const Right(1);
  }

  @override
  Future<Either<Failure, int>>? updateWalkMedia(WalkMedia wm) async =>
      const Right(1);

  @override
  Future<Either<Failure, int>>? deleteWalkMedia(int id) async {
    _db.walkMedia.removeWhere((w) => w.id == id);
    return const Right(1);
  }
}

class FakeSyncRepository implements SyncRepository {
  @override
  Future<Either<Failure, sync_entity.SyncEntity>>? sync(String email) async {
    final trainers = [
      const sync_entity.TrainerEntity(
          id: 1,
          name: 'Alex Trainer',
          email: 'alex@fit.com',
          password: 'x',
          institutionEmail: 'inst@fit.com',
          gender: 'M',
          age: 30,
          role: 'trainer'),
      const sync_entity.TrainerEntity(
          id: 2,
          name: 'Sam Coach',
          email: 'sam@fit.com',
          password: 'x',
          institutionEmail: 'inst@fit.com',
          gender: 'F',
          age: 28,
          role: 'trainer'),
    ];
    const company = sync_entity.CompanyEntity(
        id: 1,
        name: 'Fit Co',
        email: 'info@fit.co',
        phone: '000',
        address: 'Earth');
    final data = sync_entity.SyncDataEntity(
        trainers: trainers, company: company, message: 'ok');
    return Right<Failure, sync_entity.SyncEntity>(
        sync_entity.SyncEntity(data: data));
  }
}
