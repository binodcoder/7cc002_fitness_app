import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/core/widgets/custom_button.dart';
import 'package:fitness_app/core/widgets/custom_text_form_field.dart';
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
  TimeOfDay _availEnd = const TimeOfDay(hour: 17, minute: 0);
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

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

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
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppHeight.h20),
                      // Role (read-only)
                      Builder(
                        builder: (context) {
                          final role = (_prefs.getString('role') ?? 'standard').trim();
                          String labelFor(String r) {
                            if (r.toLowerCase() == 'trainer') return 'Trainer';
                            if (r.isEmpty) return 'Standard';
                            return r[0].toUpperCase() + r.substring(1);
                          }
                          return InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Role',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            child: Text(labelFor(role)),
                          );
                        },
                      ),
                      SizedBox(height: AppHeight.h10),

                      // Name
                      CustomTextFormField(
                        label: 'Name',
                        controller: _nameCtrl,
                        hint: 'Your full name',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? '*Required'
                            : null,
                      ),
                      SizedBox(height: AppHeight.h10),

                      // Gender
                      Text(
                        'Gender',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: _selectedGender,
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: _selectedGender,
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Other'),
                        value: 'Other',
                        groupValue: _selectedGender,
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Prefer not to say'),
                        value: 'Prefer not to say',
                        groupValue: _selectedGender,
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                      SizedBox(height: AppHeight.h10),

                      // Age
                      CustomTextFormField(
                        label: 'Age',
                        controller: _ageCtrl,
                        hint: 'e.g., 28',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: AppHeight.h10),

                      // Height
                      CustomTextFormField(
                        label: 'Height (cm)',
                        controller: _heightCtrl,
                        hint: 'e.g., 175',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                      SizedBox(height: AppHeight.h10),

                      // Weight
                      CustomTextFormField(
                        label: 'Weight (kg)',
                        controller: _weightCtrl,
                        hint: 'e.g., 70.5',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                      SizedBox(height: AppHeight.h10),

                      // Goal
                      CustomTextFormField(
                        label: 'Goal',
                        controller: _goalCtrl,
                        hint: 'e.g., Lose weight, Build muscle',
                        minLines: 2,
                        maxLines: 4,
                      ),
                      // Availability section (trainer only)
                      if (_prefs.getString('role') == 'trainer') ...[
                        SizedBox(height: AppHeight.h20),
                        Text('My Availability',
                            style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: AppHeight.h10),
                        Card(
                          elevation: 0.5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
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
                                            '${_dow(_availDate)}, ${_availDate.year.toString().padLeft(4, '0')}-${_availDate.month.toString().padLeft(2, '0')}-${_availDate.day.toString().padLeft(2, '0')}',
                                          ),
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
                                            labelText: 'Start (HH:mm)',
                                            border: OutlineInputBorder(),
                                            isDense: true,
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.schedule,
                                                  size: 18),
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
                                            labelText: 'End (HH:mm)',
                                            border: OutlineInputBorder(),
                                            isDense: true,
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.timelapse,
                                                  size: 18),
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
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final s = _fmtTime(_availStart);
                                      final e = _fmtTime(_availEnd);
                                      Duration parse(String t) {
                                        final p = t.split(':');
                                        return Duration(
                                            hours: int.parse(p[0]),
                                            minutes: int.parse(p[1]));
                                      }
                                      final sd = parse(s);
                                      final ed = parse(e);
                                      if (ed <= sd) {
                                        Fluttertoast.showToast(
                                          msg:
                                              'End time must be after start time for availability',
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor:
                                              Theme.of(context).colorScheme.error,
                                        );
                                        return;
                                      }
                                      // Prevent overlapping slots on the same day
                                      bool overlaps() {
                                        for (final a in _availability) {
                                          final ap = a.startTime.split(':');
                                          final bp = a.endTime.split(':');
                                          final aStart = Duration(
                                              hours: int.parse(ap[0]),
                                              minutes: int.parse(ap[1]));
                                          final aEnd = Duration(
                                              hours: int.parse(bp[0]),
                                              minutes: int.parse(bp[1]));
                                          final intersect =
                                              sd < aEnd && ed > aStart;
                                          if (intersect) return true;
                                        }
                                        return false;
                                      }
                                      if (overlaps()) {
                                        Fluttertoast.showToast(
                                          msg:
                                              'This time overlaps with an existing slot.',
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor:
                                              Theme.of(context).colorScheme.error,
                                        );
                                        return;
                                      }
                                      await _availabilityService.addSlot(
                                        date: _availDate,
                                        startTime: s,
                                        endTime: e,
                                      );
                                      await _loadAvailability();
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add Slot'),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if (_availability.isEmpty)
                                  Text(
                                    'No availability added for this date.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6)),
                                  )
                                else
                                  ListView.separated(
                                    itemCount: _availability.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (_, __) => const Divider(
                                      height: 8,
                                      thickness: 0.4,
                                    ),
                                    itemBuilder: (context, i) {
                                      final a = _availability[i];
                                      return Dismissible(
                                        key: ValueKey('avail_${a.id}'),
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          color: Colors.transparent,
                                        ),
                                        secondaryBackground: Container(
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error
                                              .withValues(alpha: 0.1),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(Icons.delete,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Delete',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        confirmDismiss: (dir) async {
                                          // Optionally add a confirmation dialog in the future
                                          return true;
                                        },
                                        onDismissed: (_) async {
                                          await _availabilityService
                                              .deleteSlot(a.id);
                                          await _loadAvailability();
                                        },
                                        child: ListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          leading: const Icon(
                                              Icons.event_available),
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
                      ],

                      SizedBox(height: AppHeight.h20),
                      CustomButton(
                        onPressed: isBusy
                            ? () {}
                            : () async {
                                if (!_formKey.currentState!.validate()) return;
                                final p =
                                    state.profile ?? UserProfile.empty('');
                                final updated = p.copyWith(
                                  name: _nameCtrl.text.trim(),
                                  age: int.tryParse(_ageCtrl.text.trim()) ?? 0,
                                  gender: (_selectedGender ?? '').trim(),
                                  height: double.tryParse(
                                          _heightCtrl.text.trim()) ??
                                      0,
                                  weight: double.tryParse(
                                          _weightCtrl.text.trim()) ??
                                      0,
                                  goal: _goalCtrl.text.trim(),
                                  photoUrl: _photoUrl ?? '',
                                  lastUpdated: DateTime.now(),
                                );
                                _bloc.add(ProfileSaved(updated));
                              },
                        child: Text(
                          'Save Profile',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
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
