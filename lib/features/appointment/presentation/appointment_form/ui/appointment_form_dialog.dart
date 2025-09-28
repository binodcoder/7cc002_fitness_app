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

import 'package:fitness_app/core/widgets/custom_button.dart';
import '../bloc/appointment_form_bloc.dart';
import '../bloc/appointment_form_state.dart';
import 'package:fitness_app/features/appointment/presentation/appointment_form/widgets/trainer_dropdown.dart';
// Use common text field for date/time with labels
import 'package:fitness_app/core/widgets/custom_text_form_field.dart';

class AppointmentFormDialog extends StatefulWidget {
  final Appointment? appointment;
  final DateTime? focusedDay;
  const AppointmentFormDialog({
    Key? key,
    this.appointment,
    this.focusedDay,
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
  TimeOfDay _selectedStartTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay _selectedEndTime = const TimeOfDay(hour: 00, minute: 00);
  final DateFormat _dateFmt = DateFormat('yyyy-MM-dd');
  final _formKey = GlobalKey<FormState>();
  final AppointmentFormBloc formBloc = sl<AppointmentFormBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  void _initializeDefaults() {
    // Use focusedDay when provided, otherwise default to today
    _selectedDate = widget.focusedDay ?? DateTime.now();
    _dateController.text = _dateFmt.format(_selectedDate);
    // Leave time empty so hints show and UI feels lighter
    _startTimeController.text = '';
    _endTimeController.text = '';
  }

  void _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = _dateFmt.format(_selectedDate);
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedStartTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        });

    if (pickedTime != null && pickedTime != _selectedStartTime) {
      setState(() {
        _selectedStartTime = pickedTime;
        _startTimeController.text = _formatTimeOfDay(_selectedStartTime);
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedEndTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        });

    if (pickedTime != null && pickedTime != _selectedEndTime) {
      setState(() {
        _selectedEndTime = pickedTime;
        _endTimeController.text = _formatTimeOfDay(_selectedEndTime);
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hours = timeOfDay.hour.toString().padLeft(2, '0');
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
    const seconds = '00';
    return '$hours:$minutes:$seconds';
  }

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
  }

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
      buildWhen: (previous, current) => current is! AppointmentFormActionState,
      listener: (context, state) {
        if (state is AppointmentFormLoading) {
        } else if (state is AppointmentCreateSuccess) {
          if (!mounted) return;
          Navigator.pop(context);
        } else if (state is AppointmentUpdateSuccess) {
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is AppointmentFormError) {
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
            if (widget.appointment != null) {
              _selectedTrainer = successState.syncEntity.data.trainers
                  .where((TrainerEntity element) =>
                      element.id == widget.appointment!.trainerId)
                  .first;
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
                      TrainerDropdown(
                        trainers: successState.syncEntity.data.trainers,
                        selectedTrainer: _selectedTrainer,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedTrainer = newValue;
                          });
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      CustomTextFormField(
                        label: 'Date',
                        controller: _dateController,
                        hint: 'Tap to select',
                        readOnly: true,
                        onTap: () => _pickDate(context),
                        suffixIcon: const Icon(Icons.calendar_today,
                            color: ColorManager.blueGrey),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      // Time section
                      Text(
                        'Time',
                        style: getBoldStyle(
                          fontSize: FontSize.s14,
                          color: ColorManager.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              label: 'Start Time',
                              controller: _startTimeController,
                              hint: 'Tap to select',
                              readOnly: true,
                              onTap: () => _selectStartTime(context),
                              suffixIcon: const Icon(Icons.schedule,
                                  color: ColorManager.blueGrey),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextFormField(
                              label: 'End Time',
                              controller: _endTimeController,
                              hint: 'Tap to select',
                              readOnly: true,
                              onTap: () => _selectEndTime(context),
                              suffixIcon: const Icon(Icons.schedule,
                                  color: ColorManager.blueGrey),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '24-hour format',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: ColorManager.blueGrey),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      CustomTextFormField(
                        label: 'Remarks',
                        controller: _remarksController,
                        hint: 'Enter remarks',
                        minLines: 3,
                        maxLines: 5,
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      CustomButton(
                        child: Text(
                          strings.save,
                          style: getRegularStyle(
                            fontSize: FontSize.s16,
                            color: ColorManager.white,
                          ),
                        ),
                        onPressed: () async {
                          final errors = <String>[];
                          if (_selectedTrainer == null) {
                            errors.add('Please select a trainer.');
                          }
                          if (_dateController.text.trim().isEmpty) {
                            errors.add('Please select a date.');
                          }
                          if (_startTimeController.text.trim().isEmpty ||
                              _endTimeController.text.trim().isEmpty) {
                            errors.add('Please select start and end time.');
                          }

                          bool isTimeOrderValid() {
                            try {
                              final st = _startTimeController.text.trim();
                              final et = _endTimeController.text.trim();
                              if (st.isEmpty || et.isEmpty) return false;
                              Duration parse(String t) {
                                final parts = t.split(':');
                                final h = int.parse(parts[0]);
                                final m = int.parse(parts[1]);
                                final s =
                                    parts.length > 2 ? int.parse(parts[2]) : 0;
                                return Duration(
                                    hours: h, minutes: m, seconds: s);
                              }

                              final sd = parse(st);
                              final ed = parse(et);
                              return ed > sd;
                            } catch (_) {
                              return false;
                            }
                          }

                          if (!isTimeOrderValid()) {
                            errors.add('End time must be after start time.');
                          }

                          if (errors.isNotEmpty) {
                            Fluttertoast.cancel();
                            Fluttertoast.showToast(
                              msg: errors.first,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: ColorManager.error,
                            );
                            return;
                          }

                          if (widget.appointment != null) {
                            final appointmentModel = Appointment(
                              id: widget.appointment!.id,
                              date: _selectedDate,
                              endTime: _endTimeController.text,
                              startTime: _startTimeController.text,
                              trainerId: _selectedTrainer!.id,
                              userId: sharedPreferences.getInt("user_id") ?? 1,
                              remark: _remarksController.text,
                            );
                            formBloc.add(AppointmentUpdateRequested(
                                appointment: appointmentModel));
                          } else {
                            final appointmentModel = Appointment(
                              date: _selectedDate,
                              endTime: _endTimeController.text,
                              startTime: _startTimeController.text,
                              trainerId: _selectedTrainer!.id,
                              userId: sharedPreferences.getInt("user_id") ?? 1,
                              remark: _remarksController.text,
                            );
                            formBloc.add(AppointmentCreateRequested(
                                appointment: appointmentModel));
                          }
                        },
                      ),
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
