import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/features/profile/domain/entities/user_profile.dart';
import 'package:fitness_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fitness_app/core/services/image_picker_service.dart';
import 'package:fitness_app/features/appointment/infrastructure/services/availability_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _goalCtrl = TextEditingController();
  String? _photoUrl;
  String? _selectedGender; // 'Male', 'Female', 'Other', or null

  late final ProfileBloc _bloc;
  final _imagePicker = sl<ImagePickerService>();
  bool _isDialogVisible = false;
  // Availability (trainer only)
  DateTime _availDate = DateTime.now();
  TimeOfDay _availStart = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _availEnd = const TimeOfDay(hour: 10, minute: 0);
  final _availability = <AvailabilitySlot>[];
  final _availabilityService = sl<AppointmentAvailabilityService>();
  final SharedPreferences _prefs = sl<SharedPreferences>();

  String _dow(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    // DateTime.weekday: Mon=1..Sun=7
    return days[(d.weekday - 1) % 7];
  }

  String _fmtHm(String hhmmss) {
    // display helper for HH:mm:ss → HH:mm
    final p = hhmmss.split(':');
    if (p.length < 2) return hhmmss;
    return '${p[0].padLeft(2, '0')}:${p[1].padLeft(2, '0')}';
  }

  TimeOfDay _roundTo15(TimeOfDay t) {
    final total = t.hour * 60 + t.minute;
    final r = (total / 15).round() * 15;
    final h = (r ~/ 60) % 24;
    final m = r % 60;
    return TimeOfDay(hour: h, minute: m);
  }

  @override
  void initState() {
    super.initState();
    _bloc = sl<ProfileBloc>()..add(const ProfileStarted());
    _loadAvailability();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _goalCtrl.dispose();
    _bloc.close();
    super.dispose();
  }

  void _fill(UserProfile p) {
    _nameCtrl.text = p.name;
    _ageCtrl.text = p.age == 0 ? '' : p.age.toString();
    _selectedGender = _normalizeGenderLabel(p.gender);
    _heightCtrl.text = p.height == 0 ? '' : p.height.toString();
    _weightCtrl.text = p.weight == 0 ? '' : p.weight.toString();
    _goalCtrl.text = p.goal;
    _photoUrl = p.photoUrl.isEmpty ? null : p.photoUrl;
  }

  Future<void> _pickAvailDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _availDate,
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _availDate = picked);
      await _loadAvailability();
    }
  }

  Future<void> _pickAvailStart(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _availStart,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _availStart = _roundTo15(picked));
  }

  Future<void> _pickAvailEnd(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _availEnd,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _availEnd = _roundTo15(picked));
  }

  String _fmtTime(TimeOfDay t) {
    final dt = DateTime(1970, 1, 1, t.hour, t.minute);
    return DateFormat('HH:mm').format(dt);
  }

  Future<void> _loadAvailability() async {
    if (_prefs.getString('role') != 'trainer') return;
    final list = await _availabilityService.listMineOnDate(_availDate);
    setState(() {
      _availability
        ..clear()
        ..addAll(list);
    });
  }

  String? _normalizeGenderLabel(String value) {
    final v = value.trim().toLowerCase();
    if (v.isEmpty || v == '-') return null;
    if (v == 'm' || v == 'male') return 'Male';
    if (v == 'f' || v == 'female') return 'Female';
    if (v == 'o' || v == 'other') return 'Other';
    if (v == 'n' || v == 'prefer not to say') return 'Prefer not to say';
    // Fallback to capitalized original
    return value[0].toUpperCase() + value.substring(1);
  }

  Future<void> _saveUpdatedProfile() async {
    final base = _bloc.state.profile ?? UserProfile.empty('');
    final updated = base.copyWith(
      name: _nameCtrl.text.trim(),
      age: int.tryParse(_ageCtrl.text.trim()) ?? 0,
      gender: (_selectedGender ?? '').trim(),
      height: double.tryParse(_heightCtrl.text.trim()) ?? 0,
      weight: double.tryParse(_weightCtrl.text.trim()) ?? 0,
      goal: _goalCtrl.text.trim(),
      photoUrl: _photoUrl ?? '',
      lastUpdated: DateTime.now(),
    );
    _bloc.add(ProfileSaved(updated));
  }

  Future<void> _promptText({
    required String title,
    required TextEditingController target,
    TextInputType keyboardType = TextInputType.text,
    int minLines = 1,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) async {
    final value = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _TextEditPage(
          title: title,
          initial: target.text,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          validator: validator,
        ),
      ),
    );
    if (value != null) {
      setState(() => target.text = value.trim());
      await _saveUpdatedProfile();
    }
  }

  Future<void> _editName() async {
    await _promptText(
      title: 'Name',
      target: _nameCtrl,
      keyboardType: TextInputType.name,
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Name is required' : null,
    );
  }

  Future<void> _editAge() async {
    await _promptText(
      title: 'Age',
      target: _ageCtrl,
      keyboardType: TextInputType.number,
      validator: (v) {
        final t = (v ?? '').trim();
        if (t.isEmpty) return 'Age is required';
        final n = int.tryParse(t);
        if (n == null || n < 0 || n > 120) return 'Enter a valid age';
        return null;
      },
    );
  }

  Future<void> _editHeight() async {
    await _promptText(
      title: 'Height (cm)',
      target: _heightCtrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (v) {
        final t = (v ?? '').trim();
        if (t.isEmpty) return 'Height is required';
        final n = double.tryParse(t);
        if (n == null || n <= 0 || n > 300) return 'Enter a valid height';
        return null;
      },
    );
  }

  Future<void> _editWeight() async {
    await _promptText(
      title: 'Weight (kg)',
      target: _weightCtrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (v) {
        final t = (v ?? '').trim();
        if (t.isEmpty) return 'Weight is required';
        final n = double.tryParse(t);
        if (n == null || n <= 0 || n > 500) return 'Enter a valid weight';
        return null;
      },
    );
  }

  Future<void> _editGoal() async {
    await _promptText(
      title: 'Goal',
      target: _goalCtrl,
      minLines: 2,
      maxLines: 4,
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Goal is required' : null,
    );
  }

  Future<void> _editGender() async {
    final selected = await Navigator.of(context).push<String?>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _GenderEditPage(current: _selectedGender),
      ),
    );
    if (selected != null || _selectedGender != null) {
      setState(() => _selectedGender = selected);
      await _saveUpdatedProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: _bloc,
      listenWhen: (p, c) =>
          p.status != c.status || p.errorMessage != c.errorMessage,
      listener: (context, state) {
        if (state.status == ProfileStatus.loading ||
            state.status == ProfileStatus.saving) {
          if (!_isDialogVisible) {
            _isDialogVisible = true;
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            ).whenComplete(() => _isDialogVisible = false);
          }
          return;
        }

        // Dismiss loader if visible
        if (_isDialogVisible) {
          final navigator = Navigator.of(context, rootNavigator: true);
          if (navigator.canPop()) navigator.pop();
          _isDialogVisible = false;
        }

        if (state.status == ProfileStatus.loaded && state.profile != null) {
          _fill(state.profile!);
        } else if (state.status == ProfileStatus.saved) {
          Fluttertoast.showToast(
            msg: 'Profile updated',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).colorScheme.primary,
          );
          Navigator.of(context).maybePop();
        } else if (state.status == ProfileStatus.failure &&
            state.errorMessage != null) {
          Fluttertoast.showToast(
            msg: state.errorMessage!,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      builder: (context, state) {
        final isBusy = state.status == ProfileStatus.saving;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppWidth.w30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppHeight.h20),
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundImage:
                                  (_photoUrl != null && _photoUrl!.isNotEmpty)
                                      ? FileImage(File(_photoUrl!))
                                      : null,
                              child: (_photoUrl == null || _photoUrl!.isEmpty)
                                  ? const Icon(Icons.person, size: 48)
                                  : null,
                            ),
                            Positioned(
                              right: -4,
                              bottom: -4,
                              child: Material(
                                color: Theme.of(context).colorScheme.surface,
                                shape: const CircleBorder(),
                                elevation: 2,
                                child: IconButton(
                                  icon: const Icon(Icons.photo_camera),
                                  tooltip: 'Change photo',
                                  onPressed: () async {
                                    final path =
                                        await _imagePicker.pickFromGallery();
                                    if (path != null) {
                                      setState(() => _photoUrl = path);
                                      await _saveUpdatedProfile();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppHeight.h20),
                      // Details: read-only with per-field editing
                      // Role (always read-only)
                      Builder(
                        builder: (context) {
                          final role =
                              (_prefs.getString('role') ?? 'standard').trim();
                          String labelFor(String r) {
                            if (r.toLowerCase() == 'trainer') return 'Trainer';
                            if (r.isEmpty) return 'Standard';
                            return r[0].toUpperCase() + r.substring(1);
                          }

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Role'),
                            subtitle: Text(labelFor(role)),
                          );
                        },
                      ),
                      const Divider(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Name'),
                        subtitle: Text(
                          _nameCtrl.text.trim().isEmpty
                              ? 'Add name'
                              : _nameCtrl.text.trim(),
                        ),
                        onTap: _editName,
                        trailing: IconButton(
                          icon: Icon(
                            _nameCtrl.text.trim().isEmpty
                                ? Icons.add
                                : Icons.edit,
                          ),
                          onPressed: _editName,
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Gender'),
                        subtitle: Text(_selectedGender ?? 'Add gender'),
                        onTap: _editGender,
                        trailing: IconButton(
                          icon: Icon(
                              _selectedGender == null ? Icons.add : Icons.edit),
                          onPressed: _editGender,
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Age'),
                        subtitle: Text(
                          _ageCtrl.text.trim().isEmpty
                              ? 'Add age'
                              : _ageCtrl.text.trim(),
                        ),
                        onTap: _editAge,
                        trailing: IconButton(
                          icon: Icon(_ageCtrl.text.trim().isEmpty
                              ? Icons.add
                              : Icons.edit),
                          onPressed: _editAge,
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Height (cm)'),
                        subtitle: Text(
                          _heightCtrl.text.trim().isEmpty
                              ? 'Add height'
                              : _heightCtrl.text.trim(),
                        ),
                        onTap: _editHeight,
                        trailing: IconButton(
                          icon: Icon(_heightCtrl.text.trim().isEmpty
                              ? Icons.add
                              : Icons.edit),
                          onPressed: _editHeight,
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Weight (kg)'),
                        subtitle: Text(
                          _weightCtrl.text.trim().isEmpty
                              ? 'Add weight'
                              : _weightCtrl.text.trim(),
                        ),
                        onTap: _editWeight,
                        trailing: IconButton(
                          icon: Icon(_weightCtrl.text.trim().isEmpty
                              ? Icons.add
                              : Icons.edit),
                          onPressed: _editWeight,
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Goal'),
                        subtitle: Text(
                          _goalCtrl.text.trim().isEmpty
                              ? 'Add goal'
                              : _goalCtrl.text.trim(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: _editGoal,
                        trailing: IconButton(
                          icon: Icon(_goalCtrl.text.trim().isEmpty
                              ? Icons.add
                              : Icons.edit),
                          onPressed: _editGoal,
                        ),
                      ),
                      // Availability section (trainer only)
                      if (_prefs.getString('role') == 'trainer') ...[
                        SizedBox(height: AppHeight.h20),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.event_available),
                          title: const Text('My Availability'),
                          subtitle:
                              const Text('Manage your available time slots'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) => const MyAvailabilityDialog(),
                              ),
                            );
                          },
                        ),
                      ],

                      SizedBox(height: AppHeight.h10),

                      if (state.status == ProfileStatus.failure &&
                          state.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            state.errorMessage!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      SizedBox(height: AppHeight.h20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Full-screen dialog for managing trainer availability
class MyAvailabilityDialog extends StatefulWidget {
  const MyAvailabilityDialog({super.key});

  @override
  State<MyAvailabilityDialog> createState() => _MyAvailabilityDialogState();
}

class _MyAvailabilityDialogState extends State<MyAvailabilityDialog> {
  DateTime _availDate = DateTime.now();
  TimeOfDay _availStart = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _availEnd = const TimeOfDay(hour: 10, minute: 0);
  int _slotDurationMinutes = 60;
  final _availability = <AvailabilitySlot>[];
  final _availabilityService = sl<AppointmentAvailabilityService>();
  final SharedPreferences _prefs = sl<SharedPreferences>();
  bool _isAdding = false;

  String _fmtHm(String hhmmss) {
    final p = hhmmss.split(':');
    if (p.length < 2) return hhmmss;
    return '${p[0].padLeft(2, '0')}:${p[1].padLeft(2, '0')}';
  }

  TimeOfDay _roundTo15(TimeOfDay t) {
    final total = t.hour * 60 + t.minute;
    final r = (total / 15).round() * 15;
    final h = (r ~/ 60) % 24;
    final m = r % 60;
    return TimeOfDay(hour: h, minute: m);
  }

  TimeOfDay _addMinutes(TimeOfDay t, int minutes) {
    int total = t.hour * 60 + t.minute + minutes;
    if (total < 0) total = 0;
    if (total > 23 * 60 + 59) total = 23 * 60 + 59;
    final h = total ~/ 60;
    final m = total % 60;
    return TimeOfDay(hour: h, minute: m);
  }

  Future<void> _pickAvailDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _availDate,
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _availDate = picked);
      await _loadAvailability();
    }
  }

  Future<void> _pickAvailStart(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _availStart,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) {
      final rounded = _roundTo15(picked);
      setState(() {
        _availStart = rounded;
        _availEnd = _addMinutes(_availStart, _slotDurationMinutes);
      });
    }
  }

  Future<void> _pickAvailEnd(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _availEnd,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _availEnd = _roundTo15(picked));
  }

  String _fmtTime(TimeOfDay t) {
    final dt = DateTime(1970, 1, 1, t.hour, t.minute);
    return DateFormat('HH:mm').format(dt);
  }

  Future<void> _loadAvailability() async {
    if (_prefs.getString('role') != 'trainer') return;
    final list = await _availabilityService.listMineOnDate(_availDate);
    setState(() {
      _availability
        ..clear()
        ..addAll(list);
    });
  }

  bool _overlapsExisting(
      Duration sd, Duration ed, List<AvailabilitySlot> list) {
    for (final a in list) {
      final ap = a.startTime.split(':');
      final bp = a.endTime.split(':');
      final aStart =
          Duration(hours: int.parse(ap[0]), minutes: int.parse(ap[1]));
      final aEnd = Duration(hours: int.parse(bp[0]), minutes: int.parse(bp[1]));
      if (sd < aEnd && ed > aStart) return true;
    }
    return false;
  }

  Future<void> _addCurrentSlot() async {
    final s = _fmtTime(_availStart);
    final e = _fmtTime(_availEnd);
    Duration parse(String t) {
      final p = t.split(':');
      return Duration(hours: int.parse(p[0]), minutes: int.parse(p[1]));
    }

    final sd = parse(s);
    final ed = parse(e);
    if (ed <= sd) {
      Fluttertoast.showToast(
        msg: 'End time must be after start time for availability',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }
    if (_overlapsExisting(sd, ed, _availability)) {
      Fluttertoast.showToast(
        msg: 'This time overlaps with an existing slot.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }
    setState(() => _isAdding = true);
    try {
      await _availabilityService.addSlot(
          date: _availDate, startTime: s, endTime: e);
      await _loadAvailability();
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  Future<void> _copyFromPreviousDay() async {
    final prev = _availDate.subtract(const Duration(days: 1));
    final src = await _availabilityService.listMineOnDate(prev);
    if (src.isEmpty) {
      Fluttertoast.showToast(
        msg: 'No slots on previous day to copy.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    final dest = await _availabilityService.listMineOnDate(_availDate);
    int added = 0;
    Duration parse(String t) {
      final p = t.split(':');
      return Duration(hours: int.parse(p[0]), minutes: int.parse(p[1]));
    }

    for (final s in src) {
      final sd = parse(s.startTime);
      final ed = parse(s.endTime);
      if (_overlapsExisting(sd, ed, dest)) continue;
      await _availabilityService.addSlot(
        date: _availDate,
        startTime: s.startTime,
        endTime: s.endTime,
      );
      added++;
    }
    await _loadAvailability();
    Fluttertoast.showToast(
      msg: added == 0 ? 'All slots already exist.' : 'Copied $added slot(s).',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _repeatForNextWeeks(int weeks) async {
    if (_availability.isEmpty) {
      Fluttertoast.showToast(
        msg: 'No slots on this day to repeat.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    int added = 0;
    for (int w = 1; w <= weeks; w++) {
      final d = _availDate.add(Duration(days: 7 * w));
      final dest = await _availabilityService.listMineOnDate(d);
      Duration parse(String t) {
        final p = t.split(':');
        return Duration(hours: int.parse(p[0]), minutes: int.parse(p[1]));
      }

      for (final s in _availability) {
        final sd = parse(s.startTime);
        final ed = parse(s.endTime);
        if (_overlapsExisting(sd, ed, dest)) continue;
        await _availabilityService.addSlot(
          date: d,
          startTime: s.startTime,
          endTime: s.endTime,
        );
        added++;
      }
    }
    Fluttertoast.showToast(
      msg: added == 0 ? 'No new slots added.' : 'Repeated $added slot(s).',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _clearAllForDay() async {
    if (_availability.isEmpty) return;
    final toDelete = List.of(_availability);
    for (final a in toDelete) {
      await _availabilityService.deleteSlot(a.id);
    }
    await _loadAvailability();
    Fluttertoast.showToast(
      msg: 'Cleared all slots for the day.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Availability'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) async {
              switch (v) {
                case 'copy_prev':
                  await _copyFromPreviousDay();
                  break;
                case 'repeat_4w':
                  await _repeatForNextWeeks(4);
                  break;
                case 'clear_day':
                  await _clearAllForDay();
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                  value: 'copy_prev', child: Text('Copy previous day here')),
              PopupMenuItem(
                  value: 'repeat_4w',
                  child: Text('Repeat this weekday for 4 weeks')),
              PopupMenuItem(value: 'clear_day', child: Text('Clear this day')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppWidth.w30, vertical: 12),
          child: Card(
            elevation: 0.5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Previous day',
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () async {
                          setState(() => _availDate =
                              _availDate.subtract(const Duration(days: 1)));
                          await _loadAvailability();
                        },
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickAvailDate(context),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            child: Text(
                                DateFormat('EEE, MMM d').format(_availDate)),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Next day',
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () async {
                          setState(() => _availDate =
                              _availDate.add(const Duration(days: 1)));
                          await _loadAvailability();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickAvailStart(context),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Start',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.schedule, size: 18),
                                const SizedBox(width: 6),
                                Text(_fmtTime(_availStart)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickAvailEnd(context),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'End',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.timelapse, size: 18),
                                const SizedBox(width: 6),
                                Text(_fmtTime(_availEnd)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: _slotDurationMinutes,
                          decoration: const InputDecoration(
                            labelText: 'Duration',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: const [15, 30, 45, 60, 90, 120]
                              .map((m) => DropdownMenuItem(
                                    value: m,
                                    child: Text('$m min'),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() {
                              _slotDurationMinutes = v;
                              _availEnd = _addMinutes(
                                  _availStart, _slotDurationMinutes);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Timezone: ${DateTime.now().timeZoneName}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _isAdding ? null : _addCurrentSlot,
                      icon: _isAdding
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add),
                      label: Text(_isAdding ? 'Adding…' : 'Add Slot'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (_availability.isEmpty)
                    Text(
                      'No availability added for this date.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6)),
                    )
                  else
                    ListView.separated(
                      itemCount: _availability.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => const Divider(
                        height: 8,
                        thickness: 0.4,
                      ),
                      itemBuilder: (context, i) {
                        final a = _availability[i];
                        return Dismissible(
                          key: ValueKey('avail_${a.id}'),
                          direction: DismissDirection.endToStart,
                          background: Container(color: Colors.transparent),
                          secondaryBackground: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            color: Theme.of(context)
                                .colorScheme
                                .error
                                .withValues(alpha: 0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.delete,
                                    color: Theme.of(context).colorScheme.error),
                                const SizedBox(width: 6),
                                Text(
                                  'Delete',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          confirmDismiss: (dir) async {
                            return true;
                          },
                          onDismissed: (_) async {
                            await _availabilityService.deleteSlot(a.id);
                            await _loadAvailability();
                          },
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.event_available),
                            title: Text(
                                '${_fmtHm(a.startTime)} – ${_fmtHm(a.endTime)}'),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TextEditPage extends StatefulWidget {
  final String title;
  final String initial;
  final TextInputType keyboardType;
  final int minLines;
  final int maxLines;
  final String? Function(String?)? validator;
  const _TextEditPage({
    required this.title,
    required this.initial,
    this.keyboardType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.validator,
  });

  @override
  State<_TextEditPage> createState() => _TextEditPageState();
}

class _TextEditPageState extends State<_TextEditPage> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.initial);
  String? _error;

  void _save() {
    final err = widget.validator?.call(_ctrl.text);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    Navigator.of(context).pop(_ctrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) {
          final fc = Theme.of(context).appBarTheme.foregroundColor ??
              Theme.of(context).colorScheme.onSurface;
          return TextButton(
            style: TextButton.styleFrom(foregroundColor: fc),
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Text('Cancel'),
          );
        }),
        title: Text(widget.title),
        actions: [
          Builder(builder: (context) {
            final fc = Theme.of(context).appBarTheme.foregroundColor ??
                Theme.of(context).colorScheme.onSurface;
            return TextButton(
              style: TextButton.styleFrom(foregroundColor: fc),
              onPressed: _save,
              child: const Text('Save'),
            );
          }),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppWidth.w30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _ctrl,
                keyboardType: widget.keyboardType,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: widget.title,
                  border: const OutlineInputBorder(),
                  isDense: true,
                  errorText: _error,
                ),
                onSubmitted: (_) => _save(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderEditPage extends StatefulWidget {
  final String? current;
  const _GenderEditPage({required this.current});

  @override
  State<_GenderEditPage> createState() => _GenderEditPageState();
}

class _GenderEditPageState extends State<_GenderEditPage> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.current;
  }

  void _save() => Navigator.of(context).pop<String?>(_selected);

  @override
  Widget build(BuildContext context) {
    final options = <String?>[
      'Male',
      'Female',
      'Other',
      'Prefer not to say',
      null
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) {
          final fc = Theme.of(context).appBarTheme.foregroundColor ??
              Theme.of(context).colorScheme.onSurface;
          return TextButton(
            style: TextButton.styleFrom(foregroundColor: fc),
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Text('Cancel'),
          );
        }),
        title: const Text('Gender'),
        actions: [
          Builder(builder: (context) {
            final fc = Theme.of(context).appBarTheme.foregroundColor ??
                Theme.of(context).colorScheme.onSurface;
            return TextButton(
              style: TextButton.styleFrom(foregroundColor: fc),
              onPressed: _save,
              child: const Text('Save'),
            );
          }),
        ],
      ),
      body: ListView(
        children: [
          for (final o in options)
            RadioListTile<String?>(
              value: o,
              groupValue: _selected,
              title: Text(o ?? 'Clear'),
              onChanged: (val) => setState(() => _selected = val),
            ),
        ],
      ),
    );
  }
}
