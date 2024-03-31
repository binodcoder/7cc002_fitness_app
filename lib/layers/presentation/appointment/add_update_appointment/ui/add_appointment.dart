import 'package:fitness_app/core/model/appointment_model.dart';

 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/model/sync_data_model.dart';
import '../../../../../global.dart';
import '../../../../../injection_container.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/values_manager.dart';
 import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../bloc/appointment_add_bloc.dart';
import '../bloc/appointment_add_event.dart';
import '../bloc/appointment_add_state.dart';

class AddAppointmentDialog extends StatefulWidget {
  final AppointmentModel? appointmentModel;
  const AddAppointmentDialog({
    Key? key,
    this.appointmentModel,
  }) : super(key: key);
  @override
  AddAppointmentDialogState createState() => AddAppointmentDialogState();
}

class AddAppointmentDialogState extends State<AddAppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  bool focus = false;
  final AppointmentAddBloc appointmentAddBloc = sl<AppointmentAddBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  void initState() {
    setDateTime();
    if (widget.appointmentModel != null) {
      _remarkController.text = widget.appointmentModel!.date.toString();
      appointmentAddBloc
          .add(AppointmentAddReadyToUpdateEvent(widget.appointmentModel!));
    } else {
      appointmentAddBloc.add(AppointmentAddInitialEvent());
    }
    super.initState();
  }

  setDateTime() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());
    _timeController.text = "00:00:00";
  }

  Trainer? selectedTrainer;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  late String _hour, _minute, _second;

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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        });

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;

        _timeController.text = formatTimeOfDay(selectedTime);
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

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _trainerController = TextEditingController();
  late double _height;
  late double _width;
  late String _setTime, _setDate;

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
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
        if (state is AddAppointmentSavedState) {
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

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.check,
                      color: ColorManager.white,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {}
                    },
                  ),
                ],
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
                      Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<Trainer>(
                            isExpanded: true,
                            hint: Text(
                              'Select Trainer',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: state.syncModel.data.trainers
                                .map((item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item.name ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: selectedTrainer,
                            onChanged: (value) {
                              setState(() {
                                selectedTrainer = value;
                              });
                            },
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 40,
                              width: 200,
                            ),
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 200,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController: _trainerController,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: _trainerController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'Search for an item...',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                return item.value
                                    .toString()
                                    .contains(searchValue);
                              },
                            ),
                            //This to clear the search value when you close the menu
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                _trainerController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Container(
                        height: AppHeight.h50,
                        margin: EdgeInsets.only(bottom: AppHeight.h10),
                        child: DropdownButtonFormField<Trainer>(
                          decoration: InputDecoration(
                            labelText: 'Trainers',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: AppWidth.w4,
                                vertical: AppHeight.h12),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 1.5),
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppRadius.r4),
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
                                    item.name ?? '',
                                    style: TextStyle(
                                      color: Colors.blueGrey[900],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            selectedTrainer = newValue;
                          },
                          value: selectedTrainer,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      DropdownButtonFormField<Trainer>(
                        decoration: InputDecoration(
                          fillColor: Colors.grey[10],
                          filled: true,
                          labelText: '  Select Trainer',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: AppWidth.w4, vertical: AppHeight.h12),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            //BorderSide(color: ColorManager.white, width: 0, style: BorderStyle.none),
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
                                  item.name ?? '',
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
                              _setDate = val!;
                            },
                            decoration: const InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.only(top: 0.0)),
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
                              _selectTime(context);
                            },
                            child: Container(
                              width: _width * 0.45,
                              height: _height * 0.1,
                              alignment: Alignment.center,
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _timeController,
                                onSaved: (String? val) {
                                  _setDate = val!;
                                },
                                decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.only(top: 0.0)),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _selectTime(context);
                            },
                            child: Container(
                              width: _width * 0.45,
                              height: _height * 0.1,
                              alignment: Alignment.center,
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _timeController,
                                onSaved: (String? val) {
                                  _setTime = val!;
                                },
                                decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.only(top: 0.0)),
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
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1.5, color: Colors.blue),
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                  width: 300, height: 50),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.resolveWith<
                                      OutlinedBorder>(
                                    (Set<MaterialState> states) {
                                      return RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(AppRadius.r4),
                                      );
                                    },
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (widget.appointmentModel != null) {
                                      // var appointmentModel = AppointmentModel(
                                      //   date: date,
                                      //   endTime: endTime,
                                      //   id: id,
                                      //   startTime: startTime,
                                      //   trainerId: selectedTrainer!.id,
                                      //   userId: 1,
                                      // );
                                      // appointmentAddBloc.add(
                                      //     AppointmentAddUpdateButtonPressEvent(
                                      //         appointmentModel));
                                    } else {
                                      var appointmentModel = AppointmentModel(

                                        date: selectedDate,
                                        endTime: _timeController.text,
                                        startTime: _timeController.text,
                                        trainerId: selectedTrainer?.id ?? 1,
                                        userId: sharedPreferences
                                                .getInt("user_id") ??
                                            1,
                                      );
                                      appointmentAddBloc.add(
                                          AppointmentAddSaveButtonPressEvent(
                                              appointmentModel));
                                    }
                                  }
                                },
                                child: Text('Save'),
                              ),
                            ),
                          )
                        ],
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
