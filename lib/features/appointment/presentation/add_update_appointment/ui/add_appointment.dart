import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';

import 'package:fitness_app/features/login/presentation/widgets/sign_in_button.dart';
import '../bloc/appointment_add_bloc.dart';
import '../bloc/appointment_add_event.dart';
import '../bloc/appointment_add_state.dart';
import 'package:fitness_app/features/appointment/presentation/add_update_appointment/widgets/trainer_dropdown.dart';
// Use common text field for date/time with labels
import 'package:fitness_app/core/widgets/custom_text_form_field.dart';

class AddAppointmentDialog extends StatefulWidget {
  final Appointment? appointment;
  final DateTime? focusedDay;
  const AddAppointmentDialog({
    Key? key,
    this.appointment,
    this.focusedDay,
  }) : super(key: key);
  @override
  AddAppointmentDialogState createState() => AddAppointmentDialogState();
}

class AddAppointmentDialogState extends State<AddAppointmentDialog> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  TrainerEntity? selectedTrainer;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = const TimeOfDay(hour: 00, minute: 00);
  final DateFormat _dateFmt = DateFormat('yyyy-MM-dd');
  final _formKey = GlobalKey<FormState>();
  final AppointmentAddBloc appointmentAddBloc = sl<AppointmentAddBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  setDateTime() {
    // Use focusedDay when provided, otherwise default to today
    selectedDate = widget.focusedDay ?? DateTime.now();
    _dateController.text = _dateFmt.format(selectedDate);
    // Leave time empty so hints show and UI feels lighter
    _startTimeController.text = '';
    _endTimeController.text = '';
  }

  void selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _dateController.text = _dateFmt.format(selectedDate);
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedStartTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        });

    if (pickedTime != null && pickedTime != selectedStartTime) {
      setState(() {
        selectedStartTime = pickedTime;
        _startTimeController.text = formatTimeOfDay(selectedStartTime);
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedEndTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        });

    if (pickedTime != null && pickedTime != selectedEndTime) {
      setState(() {
        selectedEndTime = pickedTime;
        _endTimeController.text = formatTimeOfDay(selectedEndTime);
      });
    }
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final hours = timeOfDay.hour.toString().padLeft(2, '0');
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
    const seconds =
        '00'; // TimeOfDay doesn't have seconds, so we assume it as 00
    return '$hours:$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      selectedDate = widget.appointment!.date;
      _dateController.text = _dateFmt.format(widget.appointment!.date);
      _startTimeController.text = widget.appointment!.startTime;
      _endTimeController.text = widget.appointment!.endTime;
      _remarkController.text = widget.appointment!.remark?.toString() ?? '';
    } else {
      setDateTime();
    }
    appointmentAddBloc.add(const AppointmentAddInitialEvent());
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _remarkController.dispose();
    // Close bloc since it's provided as a factory
    appointmentAddBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final size = MediaQuery.of(context).size;
    return BlocConsumer<AppointmentAddBloc, AppointmentAddState>(
      bloc: appointmentAddBloc,
      listenWhen: (previous, current) => current is AppointmentAddActionState,
      buildWhen: (previous, current) => current is! AppointmentAddActionState,
      listener: (context, state) {
        if (state is AppointmentAddLoadingState) {
        } else if (state is AddAppointmentSavedState) {
          if (!mounted) return;
          Navigator.pop(context);
        } else if (state is AddAppointmentUpdatedState) {
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is AddAppointmentErrorState) {
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
          case AppointmentAddLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          case AppointmentAddLoadedSuccessState:
            final successState = state as AppointmentAddLoadedSuccessState;
            if (widget.appointment != null) {
              selectedTrainer = successState.syncModel.data.trainers
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
                        trainers: successState.syncModel.data.trainers,
                        selectedTrainer: selectedTrainer,
                        onChanged: (newValue) {
                          setState(() {
                            selectedTrainer = newValue;
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
                        onTap: () => selectDate(context),
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
                        controller: _remarkController,
                        hint: 'Enter remarks',
                        minLines: 3,
                        maxLines: 5,
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      SigninButton(
                        child: Text(
                          strings.save,
                          style: getRegularStyle(
                            fontSize: FontSize.s16,
                            color: ColorManager.white,
                          ),
                        ),
                        onPressed: () async {
                          // Run basic checks even if form validators are absent
                          final errors = <String>[];
                          if (selectedTrainer == null) {
                            errors.add('Please select a trainer.');
                          }
                          if (_dateController.text.trim().isEmpty) {
                            errors.add('Please select a date.');
                          }
                          if (_startTimeController.text.trim().isEmpty ||
                              _endTimeController.text.trim().isEmpty) {
                            errors.add('Please select start and end time.');
                          }

                          // Validate time ordering when both provided
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
                              date: selectedDate,
                              endTime: _endTimeController.text,
                              startTime: _startTimeController.text,
                              trainerId: selectedTrainer!.id,
                              userId: sharedPreferences.getInt("user_id") ?? 1,
                              remark: _remarkController.text,
                            );
                            appointmentAddBloc.add(
                                AppointmentAddUpdateButtonPressEvent(
                                    appointment: appointmentModel));
                          } else {
                            final appointmentModel = Appointment(
                              date: selectedDate,
                              endTime: _endTimeController.text,
                              startTime: _startTimeController.text,
                              trainerId: selectedTrainer!.id,
                              userId: sharedPreferences.getInt("user_id") ?? 1,
                              remark: _remarkController.text,
                            );
                            appointmentAddBloc.add(
                                AppointmentAddSaveButtonPressEvent(
                                    appointment: appointmentModel));
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          case AddAppointmentErrorState:
            final error = state as AddAppointmentErrorState;
            return Scaffold(body: Center(child: Text(error.message)));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
