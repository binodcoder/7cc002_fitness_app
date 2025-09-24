import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart' as entity;
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
import 'package:fitness_app/core/common_widgets/date_picker_field.dart';
import 'package:fitness_app/core/common_widgets/time_picker_field.dart';
import 'package:fitness_app/core/common_widgets/text_area_field.dart';

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
  final TextEditingController _trainerController = TextEditingController();
  entity.TrainerEntity? selectedTrainer;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = const TimeOfDay(hour: 00, minute: 00);
  late double _height;
  late double _width;
  // late String _setTime, _setDate;
  final _formKey = GlobalKey<FormState>();
  bool focus = false;
  final AppointmentAddBloc appointmentAddBloc = sl<AppointmentAddBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  setDateTime() {
    selectedDate = widget.focusedDay!;
    _dateController.text = DateFormat('yyyy-MM-dd').format(widget.focusedDay!);
    _startTimeController.text = "00:00:00";
    _endTimeController.text = "00:00:00";
  }

  void selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _dateController.text = DateFormat("yyyy-MM-dd").format(selectedDate);
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
    setDateTime();
    if (widget.appointment != null) {
      selectedDate = widget.appointment!.date;
      _dateController.text =
          DateFormat('yyyy-MM-dd').format(widget.appointment!.date);
      _startTimeController.text = widget.appointment!.startTime;
      _endTimeController.text = widget.appointment!.endTime;
      _remarkController.text = widget.appointment!.remark.toString();
      // appointmentAddBloc.add(AppointmentAddReadyToUpdateEvent(widget.appointmentModel!));
      appointmentAddBloc.add(AppointmentAddInitialEvent());
    } else {
      appointmentAddBloc.add(AppointmentAddInitialEvent());
    }
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _remarkController.dispose();
    _trainerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    Size size = MediaQuery.of(context).size;
    _height = size.height;
    _width = size.width;
    return BlocConsumer<AppointmentAddBloc, AppointmentAddState>(
      bloc: appointmentAddBloc,
      listenWhen: (previous, current) => current is AppointmentAddActionState,
      buildWhen: (previous, current) => current is! AppointmentAddActionState,
      listener: (context, state) {
        if (state is AppointmentAddLoadingState) {
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return const Center(child: CircularProgressIndicator());
          //   },
          // );
        } else if (state is AddAppointmentSavedState) {
          // sourceController.clear();
          // descriptionController.clear();
          Navigator.pop(context);
        } else if (state is AddAppointmentUpdatedState) {
          // sourceController.clear();
          // descriptionController.clear();
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is AddAppointmentErrorState) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: 'Error while adding appointment',
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
                  .where((entity.TrainerEntity element) =>
                      element.id == widget.appointment!.trainerId)
                  .first;
              // _trainerController.text =
              //     successState.syncModel.data.trainers.where((Trainer element) => element.id == widget.appointmentModel!.trainerId).first.name;
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
                title: const Text(
                  'New Appointment',
                  style: TextStyle(fontSize: 16.0),
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
                      DatePickerField(
                        controller: _dateController,
                        width: _width / 1.7,
                        height: _height / 9,
                        onTap: () => selectDate(context),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TimePickerField(
                            controller: _startTimeController,
                            width: _width * 0.45,
                            height: _height * 0.1,
                            onTap: () => _selectStartTime(context),
                          ),
                          TimePickerField(
                            controller: _endTimeController,
                            width: _width * 0.45,
                            height: _height * 0.1,
                            onTap: () => _selectEndTime(context),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      TextAreaField(
                        controller: _remarkController,
                        labelText: 'Remarks',
                        hintText: 'Enter remarks',
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
                          if (_formKey.currentState!.validate()) {
                            if (widget.appointment != null) {
                              var appointmentModel = Appointment(
                                id: widget.appointment!.id,
                                date: selectedDate,
                                endTime: _endTimeController.text,
                                startTime: _startTimeController.text,
                                trainerId: selectedTrainer!.id,
                                userId: sharedPreferences.getInt("user_id")!,
                                remark: _remarkController.text,
                              );
                              appointmentAddBloc.add(
                                  AppointmentAddUpdateButtonPressEvent(
                                      appointmentModel));
                            } else {
                              var appointmentModel = Appointment(
                                date: selectedDate,
                                endTime: _endTimeController.text,
                                startTime: _startTimeController.text,
                                trainerId: selectedTrainer?.id ?? 1,
                                userId:
                                    sharedPreferences.getInt("user_id") ?? 1,
                                remark: _remarkController.text,
                              );
                              appointmentAddBloc.add(
                                  AppointmentAddSaveButtonPressEvent(
                                      appointmentModel));
                            }
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
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
