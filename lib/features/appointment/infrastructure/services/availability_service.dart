import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class AvailabilitySlot {
  final int id;
  final int trainerId;
  final DateTime date;
  final String startTime; // HH:mm:ss
  final String endTime; // HH:mm:ss

  const AvailabilitySlot({
    required this.id,
    required this.trainerId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
}

class AppointmentAvailabilityService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  fb.FirebaseAuth get _auth => fb.FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('availability');

  String _dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<int> _currentUserNumericId() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 0;
    final snap = await _firestore.collection('users').doc(uid).get();
    return (snap.data()?['id'] as num?)?.toInt() ?? 0;
  }

  Future<String> _currentUserRole() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 'standard';
    final snap = await _firestore.collection('users').doc(uid).get();
    return (snap.data()?['role'] as String?) ?? 'standard';
  }

  Future<List<AvailabilitySlot>> listForTrainerOnDate({
    required int trainerId,
    required DateTime date,
  }) async {
    QuerySnapshot<Map<String, dynamic>> qs;
    try {
      qs = await _col
          .where('trainerId', isEqualTo: trainerId)
          .where('dateKey', isEqualTo: _dateKey(date))
          .orderBy('startTime')
          .get();
    } on FirebaseException catch (e) {
      // Gracefully handle missing composite index or permission issues
      if (e.code == 'failed-precondition') {
        qs = await _col
            .where('trainerId', isEqualTo: trainerId)
            .where('dateKey', isEqualTo: _dateKey(date))
            .get();
      } else if (e.code == 'permission-denied') {
        return <AvailabilitySlot>[];
      } else {
        rethrow;
      }
    }
    final list = qs.docs.map((d) {
      final m = d.data();
      final ts = m['date'];
      final dt = ts is Timestamp
          ? ts.toDate()
          : DateTime.tryParse((ts ?? '').toString()) ?? date;
      return AvailabilitySlot(
        id: (m['id'] as num?)?.toInt() ?? 0,
        trainerId: (m['trainerId'] as num?)?.toInt() ?? 0,
        date: dt,
        startTime: (m['startTime'] as String?) ?? '',
        endTime: (m['endTime'] as String?) ?? '',
      );
    }).toList();
    // Ensure predictable ordering by start time even when DB orderBy is unavailable
    int cmp(AvailabilitySlot a, AvailabilitySlot b) {
      int hh(String t) => int.tryParse(t.split(':').first) ?? 0;
      int mm(String t) => int.tryParse(t.split(':').elementAt(1)) ?? 0;
      final ah = hh(a.startTime), am = mm(a.startTime);
      final bh = hh(b.startTime), bm = mm(b.startTime);
      if (ah != bh) return ah.compareTo(bh);
      return am.compareTo(bm);
    }

    list.sort(cmp);
    return list;
  }

  Future<List<AvailabilitySlot>> listMineOnDate(DateTime date) async {
    final me = await _currentUserNumericId();
    if (me == 0) return [];
    return listForTrainerOnDate(trainerId: me, date: date);
  }

  Future<int> addSlot({
    required DateTime date,
    required String startTime,
    required String endTime,
  }) async {
    final role = await _currentUserRole();
    if (role != 'trainer') return 0;
    final trainerId = await _currentUserNumericId();
    final id = DateTime.now().microsecondsSinceEpoch;
    await _col.doc(id.toString()).set({
      'id': id,
      'trainerId': trainerId,
      'date': Timestamp.fromDate(date),
      'dateKey': _dateKey(date),
      'startTime': startTime,
      'endTime': endTime,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return 1;
  }

  Future<int> deleteSlot(int id) async {
    await _col.doc(id.toString()).delete();
    return 1;
  }

  // Utility to validate if a given time range falls within any slot.
  Future<bool> isWithinAvailability({
    required int trainerId,
    required DateTime date,
    required String startTime,
    required String endTime,
  }) async {
    List<AvailabilitySlot> slots =
        await listForTrainerOnDate(trainerId: trainerId, date: date);

    Duration parse(String t) {
      final parts = t.split(':');
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final s = parts.length > 2 ? int.parse(parts[2]) : 0;
      return Duration(hours: h, minutes: m, seconds: s);
    }

    final sd = parse(startTime);
    final ed = parse(endTime);
    if (ed <= sd) return false;

    for (final s in slots) {
      final ssd = parse(s.startTime);
      final sed = parse(s.endTime);
      // Allow appointment fully within a slot range
      if (sd >= ssd && ed <= sed) return true;
    }
    return false;
  }

  // Returns a set of dates that have at least one availability slot
  Future<Set<DateTime>> listAvailableDatesInRange({
    required DateTime start,
    required DateTime end,
  }) async {
    // Normalize to date keys
    String key(DateTime d) => _dateKey(d);
    final startKey = key(DateTime(start.year, start.month, start.day));
    final endKey = key(DateTime(end.year, end.month, end.day));

    final qs = await _col
        .where('dateKey', isGreaterThanOrEqualTo: startKey)
        .where('dateKey', isLessThanOrEqualTo: endKey)
        .get();
    final set = <String>{};
    for (final d in qs.docs) {
      final m = d.data();
      final dk = (m['dateKey'] as String?) ?? '';
      if (dk.isNotEmpty) set.add(dk);
    }
    DateTime parseDk(String dk) {
      try {
        final p = dk.split('-');
        return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
      } catch (_) {
        return DateTime.now();
      }
    }

    return set.map(parseDk).toSet();
  }

  Future<Set<DateTime>> listAvailableDatesInRangeForTrainer({
    required int trainerId,
    required DateTime start,
    required DateTime end,
  }) async {
    String key(DateTime d) => _dateKey(DateTime(d.year, d.month, d.day));
    final startKey = key(start);
    final endKey = key(end);

    try {
      // Preferred: composite query by trainerId + dateKey range
      final qs = await _col
          .where('trainerId', isEqualTo: trainerId)
          .where('dateKey', isGreaterThanOrEqualTo: startKey)
          .where('dateKey', isLessThanOrEqualTo: endKey)
          .get();
      final set = <String>{};
      for (final d in qs.docs) {
        final m = d.data();
        final dk = (m['dateKey'] as String?) ?? '';
        if (dk.isNotEmpty) set.add(dk);
      }
      DateTime parseDk(String dk) {
        try {
          final p = dk.split('-');
          return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
        } catch (_) {
          return DateTime.now();
        }
      }
      return set.map(parseDk).toSet();
    } on FirebaseException catch (e) {
      // Fallback when composite index is missing: query by date range only,
      // then filter by trainerId client-side.
      if (e.code == 'failed-precondition') {
        final qs = await _col
            .where('dateKey', isGreaterThanOrEqualTo: startKey)
            .where('dateKey', isLessThanOrEqualTo: endKey)
            .get();
        final set = <String>{};
        for (final d in qs.docs) {
          final m = d.data();
          final tid = (m['trainerId'] as num?)?.toInt() ?? -1;
          if (tid != trainerId) continue;
          final dk = (m['dateKey'] as String?) ?? '';
          if (dk.isNotEmpty) set.add(dk);
        }
        DateTime parseDk(String dk) {
          try {
            final p = dk.split('-');
            return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
          } catch (_) {
            return DateTime.now();
          }
        }
        return set.map(parseDk).toSet();
      }
      if (e.code == 'permission-denied') {
        return <DateTime>{};
      }
      rethrow;
    }
  }
}
