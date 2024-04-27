import 'package:fitness_app/core/model/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/model/sync_data_model.dart';
import '../../../../../injection_container.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/font_manager.dart';
import '../../../../../resources/strings_manager.dart';
import '../../../../../resources/styles_manager.dart';
import '../../../../../resources/values_manager.dart';
import 'package:intl/intl.dart';
import '../../../login/widgets/sign_in_button.dart';
import '../bloc/appointment_add_bloc.dart';
import '../bloc/appointment_add_event.dart';
import '../bloc/appointment_add_state.dart';

class AddAppointmentDialog extends StatefulWidget {
  final AppointmentModel? appointmentModel;
  final DateTime? focusedDay;
  const AddAppointmentDialog({
    Key? key,
    this.appointmentModel,
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
  Trainer? selectedTrainer;
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
    const seconds = '00'; // TimeOfDay doesn't have seconds, so we assume it as 00
    return '$hours:$minutes:$seconds';
  }

  @override
  void initState() {
    setDateTime();
    if (widget.appointmentModel != null) {
      selectedDate = widget.appointmentModel!.date;
      _dateController.text = DateFormat('yyyy-MM-dd').format(widget.appointmentModel!.date);
      _startTimeController.text = widget.appointmentModel!.startTime;
      _endTimeController.text = widget.appointmentModel!.endTime;
      _remarkController.text = widget.appointmentModel!.remark.toString();
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
        } else if (state is AddAppointmentErrorState) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: 'Username or Password is Incorrect.',
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
            if (widget.appointmentModel != null) {
              selectedTrainer =
                  successState.syncModel.data.trainers.where((Trainer element) => element.id == widget.appointmentModel!.trainerId).first;
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
                      DropdownButtonFormField<Trainer>(
                        decoration: InputDecoration(
                          fillColor: Colors.grey[10],
                          filled: true,
                          labelText: '  Select Trainer',
                          contentPadding: EdgeInsets.symmetric(horizontal: AppWidth.w4, vertical: AppHeight.h12),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppRadius.r10),
                            ),
                          ),
                        ),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconEnabledColor: ColorManager.blue,
                        iconSize: 30,
                        items: state.syncModel.data.trainers.map((item) {
                          return DropdownMenuItem<Trainer>(
                            value: item,
                            child: Container(
                              margin: const EdgeInsets.only(left: 1),
                              padding: const EdgeInsets.only(left: 10),
                              height: 55,
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    color: ColorManager.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedTrainer = newValue;
                          });
                        },
                        value: selectedTrainer,
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      InkWell(
                        onTap: () {
                          selectDate(context);
                        },
                        child: Container(
                          width: _width / 1.7,
                          height: _height / 9,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: TextFormField(
                            style: const TextStyle(fontSize: 40),
                            textAlign: TextAlign.center,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _dateController,
                            onSaved: (String? val) {
                              //  _setDate = val!;
                            },
                            decoration: const InputDecoration(
                                disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none), contentPadding: EdgeInsets.only(top: 0.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _selectStartTime(context);
                            },
                            child: Container(
                              width: _width * 0.45,
                              height: _height * 0.1,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Colors.grey[200]),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _startTimeController,
                                onSaved: (String? val) {
                                  // _setDate = val!;
                                },
                                decoration: const InputDecoration(
                                  disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.only(
                                    top: 0.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _selectEndTime(context);
                            },
                            child: Container(
                              width: _width * 0.45,
                              height: _height * 0.1,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Colors.grey[200]),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _endTimeController,
                                onSaved: (String? val) {
                                  //_setTime = val!;
                                },
                                decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none), contentPadding: EdgeInsets.only(top: 0.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          maxLines: 4,
                          minLines: 2,
                          controller: _remarkController,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                              borderRadius: BorderRadius.circular(AppRadius.r4),
                            ),
                            labelText: 'Remarks',
                            hintText: 'Enter remarks',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      SigninButton(
                        child: Text(
                          AppStrings.save,
                          style: getRegularStyle(
                            fontSize: FontSize.s16,
                            color: ColorManager.white,
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (widget.appointmentModel != null) {
                              var appointmentModel = AppointmentModel(
                                id: widget.appointmentModel!.id,
                                date: selectedDate,
                                endTime: _endTimeController.text,
                                startTime: _startTimeController.text,
                                trainerId: selectedTrainer!.id,
                                userId: sharedPreferences.getInt("user_id")!,
                                remark: _remarkController.text,
                              );
                              appointmentAddBloc.add(AppointmentAddUpdateButtonPressEvent(appointmentModel));
                            } else {
                              var appointmentModel = AppointmentModel(
                                date: selectedDate,
                                endTime: _startTimeController.text,
                                startTime: _endTimeController.text,
                                trainerId: selectedTrainer?.id ?? 1,
                                userId: sharedPreferences.getInt("user_id") ?? 1,
                                remark: _remarkController.text,
                              );
                              appointmentAddBloc.add(AppointmentAddSaveButtonPressEvent(appointmentModel));
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
