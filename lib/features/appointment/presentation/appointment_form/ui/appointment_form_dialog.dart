import 'package:fitness_app/features/appointment/presentation/appointment_form/bloc/appointment_form_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';

import '../bloc/appointment_form_bloc.dart';
import '../bloc/appointment_form_state.dart';
import 'package:fitness_app/features/appointment/presentation/appointment_form/widgets/trainer_dropdown.dart';
// Use common text field for date/time with labels
import 'package:fitness_app/core/services/availability_service.dart';

class AppointmentFormDialog extends StatefulWidget {
  final Appointment? appointment;
  final DateTime? focusedDay;
  final int? preselectedTrainerId;
  const AppointmentFormDialog({
    Key? key,
    this.appointment,
    this.focusedDay,
    this.preselectedTrainerId,
  }) : super(key: key);
  @override
  State<AppointmentFormDialog> createState() => _AppointmentFormDialogState();
}

class _AppointmentFormDialogState extends State<AppointmentFormDialog> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  TrainerEntity? _selectedTrainer;
  DateTime _selectedDate = DateTime.now();
  final DateFormat _dateFmt = DateFormat('yyyy-MM-dd');
  final _formKey = GlobalKey<FormState>();
  final AppointmentFormBloc formBloc = sl<AppointmentFormBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();
  final AppointmentAvailabilityService _availabilityService =
      sl<AppointmentAvailabilityService>();
  List<AvailabilitySlot> _availableSlots = [];
  bool _loadingSlots = false;
  bool _didInitialSlotsLoad = false;
  int? _selectedSlotId;
  bool _suppressLoadingOverlay =
      false; // avoid full-screen spinner on incremental saves

  Future<bool> _timesAreInOrder() {
    try {
      final st = _startTimeController.text.trim();
      final et = _endTimeController.text.trim();
      if (st.isEmpty || et.isEmpty) return Future.value(false);
      Duration parse(String t) {
        final parts = t.split(':');
        final h = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        final s = parts.length > 2 ? int.parse(parts[2]) : 0;
        return Duration(hours: h, minutes: m, seconds: s);
      }

      final sd = parse(st);
      final ed = parse(et);
      return Future.value(ed > sd);
    } catch (_) {
      return Future.value(false);
    }
  }

  bool _hasMinimumFields() {
    return _selectedTrainer != null &&
        _dateController.text.trim().isNotEmpty &&
        _startTimeController.text.trim().isNotEmpty &&
        _endTimeController.text.trim().isNotEmpty;
  }

  Future<void> _saveIncremental() async {
    // Only proceed if required fields are present
    if (!_hasMinimumFields()) return;
    if (!await _timesAreInOrder()) {
      Fluttertoast.showToast(
        msg: 'End time must be after start time.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
      return;
    }
    // Validate against trainer availability
    final ok = await _availabilityService.isWithinAvailability(
      trainerId: _selectedTrainer!.id,
      date: _selectedDate,
      startTime: _startTimeController.text,
      endTime: _endTimeController.text,
    );
    if (!ok) {
      Fluttertoast.showToast(
        msg: 'Selected time is outside trainer availability.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
      return;
    }
    _suppressLoadingOverlay = true;
    final model = Appointment(
      id: widget.appointment?.id,
      date: _selectedDate,
      endTime: _endTimeController.text,
      startTime: _startTimeController.text,
      trainerId: _selectedTrainer!.id,
      userId: sharedPreferences.getInt("user_id") ?? 1,
      remark: _remarksController.text,
      status: widget.appointment?.status ?? 'pending',
    );
    if (widget.appointment != null) {
      formBloc.add(AppointmentUpdateRequested(appointment: model));
    } else {
      formBloc.add(AppointmentCreateRequested(appointment: model));
    }
  }

  void _shiftDay(int deltaDays) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: deltaDays));
      _dateController.text = _dateFmt.format(_selectedDate);
      _selectedSlotId = null;
      _startTimeController.text = '';
      _endTimeController.text = '';
    });
    _loadSlots();
  }

  void _initializeDefaults() {
    // Use focusedDay when provided, otherwise default to today
    _selectedDate = widget.focusedDay ?? DateTime.now();
    _dateController.text = _dateFmt.format(_selectedDate);
    // Leave time empty so hints show and UI feels lighter
    _startTimeController.text = '';
    _endTimeController.text = '';
  }

  // Removed legacy date/time pickers; the dialog now uses
  // availability-based slot selection and normalized inputs.

  // Legacy time formatting helpers removed; inputs are normalized as HH:mm[:ss]

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      _selectedDate = widget.appointment!.date;
      _dateController.text = _dateFmt.format(widget.appointment!.date);
      _startTimeController.text = widget.appointment!.startTime;
      _endTimeController.text = widget.appointment!.endTime;
      _remarksController.text = widget.appointment!.remark?.toString() ?? '';
    } else {
      _initializeDefaults();
    }
    formBloc.add(const AppointmentFormInitialized());
    // Slots will load after trainer selection is resolved in builder
  }

  Future<void> _loadSlots() async {
    if (_selectedTrainer == null) {
      setState(() {
        _availableSlots = [];
        _loadingSlots = false;
        _selectedSlotId = null;
        _startTimeController.text = '';
        _endTimeController.text = '';
      });
      return;
    }
    setState(() => _loadingSlots = true);
    try {
      final slots = await _availabilityService.listForTrainerOnDate(
        trainerId: _selectedTrainer!.id,
        date: _selectedDate,
      );
      setState(() {
        _availableSlots = slots;
        if (_selectedSlotId != null &&
            !_availableSlots.any((s) => s.id == _selectedSlotId)) {
          // Clear selection if it no longer exists
          _selectedSlotId = null;
          _startTimeController.text = '';
          _endTimeController.text = '';
        }
      });
    } finally {
      if (mounted) setState(() => _loadingSlots = false);
    }
  }

  void _applySlot(AvailabilitySlot s) {
    // Pure assignment; caller wraps with setState
    _selectedSlotId = s.id;
    _startTimeController.text = s.startTime;
    _endTimeController.text = s.endTime;
    // No in-memory TimeOfDay state needed; controllers hold normalized strings
  }

  // (text editor class is defined below the widget class)

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _remarksController.dispose();
    formBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final size = MediaQuery.of(context).size;
    return BlocConsumer<AppointmentFormBloc, AppointmentFormState>(
      bloc: formBloc,
      listenWhen: (previous, current) => current is AppointmentFormActionState,
      buildWhen: (previous, current) {
        if (_suppressLoadingOverlay && current is AppointmentFormLoading) {
          return false; // keep UI, avoid full-screen spinner on incremental save
        }
        return current is! AppointmentFormActionState;
      },
      listener: (context, state) {
        if (state is AppointmentCreateSuccess ||
            state is AppointmentUpdateSuccess) {
          if (_suppressLoadingOverlay) {
            _suppressLoadingOverlay = false;
            Fluttertoast.showToast(
              msg: 'Saved',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          } else {
            if (!mounted) return;
            Navigator.pop(context);
          }
        } else if (state is AppointmentFormError) {
          _suppressLoadingOverlay = false;
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: state.message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case AppointmentFormLoading:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          case AppointmentFormLoaded:
            final successState = state as AppointmentFormLoaded;
            final bool isTrainer =
                sharedPreferences.getString('role') == 'trainer';
            if (widget.appointment != null) {
              _selectedTrainer = successState.syncEntity.data.trainers
                  .where((TrainerEntity element) =>
                      element.id == widget.appointment!.trainerId)
                  .first;
              if (!_didInitialSlotsLoad) {
                _didInitialSlotsLoad = true;
                _loadSlots();
              }
            } else {
              // Auto-select trainer for initial load
              if (_selectedTrainer == null && !_didInitialSlotsLoad) {
                _didInitialSlotsLoad = true;
                final trainers = successState.syncEntity.data.trainers;
                TrainerEntity? initial;
                if (isTrainer) {
                  // Pick myself when I am a trainer
                  final myNumericId = sharedPreferences.getInt('user_id') ?? 0;
                  initial = trainers
                      .where((t) => t.id == myNumericId)
                      .cast<TrainerEntity?>()
                      .firstWhere((e) => e != null, orElse: () => null);
                }
                if (initial == null && widget.preselectedTrainerId != null) {
                  initial = trainers
                      .where((t) => t.id == widget.preselectedTrainerId)
                      .cast<TrainerEntity?>()
                      .firstWhere((e) => e != null, orElse: () => null);
                }
                initial =
                    initial ?? (trainers.isNotEmpty ? trainers.first : null);
                if (initial != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    setState(() => _selectedTrainer = initial);
                    _loadSlots();
                  });
                }
              }
            }

            return Scaffold(
              appBar: AppBar(
                backgroundColor: ColorManager.primary,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                centerTitle: true,
                title: Text(
                  strings.addAppointment,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      // Trainers cannot change trainer; lock to self
                      if (!(sharedPreferences.getString('role') == 'trainer'))
                        TrainerDropdown(
                          trainers: successState.syncEntity.data.trainers,
                          selectedTrainer: _selectedTrainer,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedTrainer = newValue;
                            });
                            _loadSlots();
                          },
                        )
                      else
                        InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Trainer',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _selectedTrainer?.name.isNotEmpty == true
                                ? _selectedTrainer!.name
                                : 'Me',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: ColorManager.primary),
                          ),
                        ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      // Availability list for selected trainer/date
                      Text(
                        'Available Slots',
                        style: getBoldStyle(
                          fontSize: FontSize.s14,
                          color: ColorManager.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            tooltip: 'Previous day',
                            icon: const Icon(Icons.chevron_left),
                            color: ColorManager.primary,
                            onPressed: () => _shiftDay(-1),
                          ),
                          Text(
                            _dateFmt.format(_selectedDate),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          IconButton(
                            tooltip: 'Next day',
                            icon: const Icon(Icons.chevron_right),
                            color: ColorManager.primary,
                            onPressed: () => _shiftDay(1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (_selectedSlotId != null)
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.25),
                              ),
                            ),
                            child: Text(
                              '${_startTimeController.text} – ${_endTimeController.text}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        )
                      else if (_availableSlots.isNotEmpty)
                        Center(
                          child: Text(
                            'Tap a slot below to select a time',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      if (_selectedTrainer == null)
                        Text(
                          'Select a trainer to view availability.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: ColorManager.blueGrey),
                        )
                      else if (_loadingSlots)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: LinearProgressIndicator(),
                        )
                      else if (_availableSlots.isEmpty)
                        Text(
                          'No availability for this date.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableSlots
                              .map((s) => ChoiceChip(
                                    label:
                                        Text('${s.startTime} – ${s.endTime}'),
                                    selected: _selectedSlotId == s.id,
                                    selectedColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.15),
                                    onSelected: (sel) {
                                      setState(() {
                                        if (sel) {
                                          _applySlot(s);
                                        } else {
                                          _selectedSlotId = null;
                                          _startTimeController.text = '';
                                          _endTimeController.text = '';
                                        }
                                      });
                                      if (sel) {
                                        _saveIncremental();
                                      }
                                    },
                                  ))
                              .toList(),
                        ),
                      SizedBox(height: size.height * 0.02),
                      SizedBox(height: size.height * 0.01),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Remarks'),
                        subtitle: Text(
                          _remarksController.text.trim().isEmpty
                              ? 'Tap to add remarks'
                              : _remarksController.text.trim(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Icon(
                          _remarksController.text.trim().isEmpty
                              ? Icons.add
                              : Icons.edit,
                        ),
                        onTap: () async {
                          final v = await Navigator.of(context).push<String>(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (_) => _TextEditPage(
                                title: 'Remarks',
                                initial: _remarksController.text,
                                minLines: 3,
                                maxLines: 5,
                              ),
                            ),
                          );
                          if (v != null) {
                            setState(() => _remarksController.text = v.trim());
                            await _saveIncremental();
                          }
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      // Removed bottom Save button; changes persist incrementally
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          case AppointmentFormError:
            final error = state as AppointmentFormError;
            return Scaffold(body: Center(child: Text(error.message)));
          default:
            return const SizedBox();
        }
      },
    );
  }
}

class _TextEditPage extends StatefulWidget {
  final String title;
  final String initial;
  final int minLines;
  final int maxLines;
  const _TextEditPage({
    required this.title,
    required this.initial,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  State<_TextEditPage> createState() => _TextEditPageState();
}

class _TextEditPageState extends State<_TextEditPage> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.initial);
  String? _error;

  void _save() {
    // No heavy validation for remarks; ensure not null
    final text = _ctrl.text.trim();
    if (widget.maxLines > 1 && text.isEmpty) {
      setState(() => _error = null);
    }
    Navigator.of(context).pop<String>(text);
  }

  @override
  Widget build(BuildContext context) {
    final fc = Theme.of(context).appBarTheme.foregroundColor ??
        Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: TextButton(
          style: TextButton.styleFrom(foregroundColor: fc),
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('Cancel'),
        ),
        title: Text(widget.title),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: fc),
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _ctrl,
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
        ),
      ),
    );
  }
}
