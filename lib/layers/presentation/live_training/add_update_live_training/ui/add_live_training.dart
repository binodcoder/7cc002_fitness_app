import 'package:fitness_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/model/live_training_model.dart';
import '../../../../../injection_container.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/values_manager.dart';
import 'package:intl/intl.dart';
import '../bloc/live_training_add_bloc.dart';
import '../bloc/live_training_add_event.dart';
import '../bloc/live_training_add_state.dart';

class AddLiveTrainingDialog extends StatefulWidget {
  final LiveTrainingModel? liveTrainingModel;

  const AddLiveTrainingDialog({
    Key? key,
    this.liveTrainingModel,
  }) : super(key: key);
  @override
  AddLiveTrainingDialogState createState() => AddLiveTrainingDialogState();
}

class AddLiveTrainingDialogState extends State<AddLiveTrainingDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = const TimeOfDay(hour: 00, minute: 00);
  late String _hour, _minute, _second;
  late double _height;
  late double _width;
  late String _setTime, _setDate;
  final _formKey = GlobalKey<FormState>();
  bool focus = false;
  final LiveTrainingAddBloc liveTrainingAddBloc = sl<LiveTrainingAddBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  setDateTime() {
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
    if (widget.liveTrainingModel != null) {
      _titleController.text = widget.liveTrainingModel!.title;
      selectedDate = widget.liveTrainingModel!.trainingDate;
      _dateController.text = DateFormat('yyyy-MM-dd').format(widget.liveTrainingModel!.trainingDate);
      _startTimeController.text = widget.liveTrainingModel!.startTime;
      _endTimeController.text = widget.liveTrainingModel!.endTime;
      _descriptionController.text = widget.liveTrainingModel!.description;
      // LiveTrainingAddBloc.add(LiveTrainingAddReadyToUpdateEvent(widget.LiveTrainingModel!));
      liveTrainingAddBloc.add(LiveTrainingAddInitialEvent());
    } else {
      liveTrainingAddBloc.add(LiveTrainingAddInitialEvent());
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _height = size.height;
    _width = size.width;
    return BlocConsumer<LiveTrainingAddBloc, LiveTrainingAddState>(
      bloc: liveTrainingAddBloc,
      listenWhen: (previous, current) => current is LiveTrainingAddActionState,
      buildWhen: (previous, current) => current is! LiveTrainingAddActionState,
      listener: (context, state) {
        if (state is AddLiveTrainingSavedState) {
          // sourceController.clear();
          // descriptionController.clear();
          Navigator.pop(context);
        } else if (state is AddLiveTrainingUpdatedState) {
          // sourceController.clear();
          // descriptionController.clear();
          Navigator.pop(context);
        } else if (state is AddLiveTrainingErrorState) {
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
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: const Text(
              AppStrings.addLiveTraining,
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 15.0),
                    child: TextFormField(
                      controller: _titleController,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                          borderRadius: BorderRadius.circular(AppRadius.r4),
                        ),
                        labelText: 'Title',
                        hintText: 'Enter Title',
                      ),
                    ),
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
                              _setDate = val!;
                            },
                            decoration: const InputDecoration(
                                disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none), contentPadding: EdgeInsets.only(top: 0.0)),
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
                              _setTime = val!;
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
                      controller: _descriptionController,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                          borderRadius: BorderRadius.circular(AppRadius.r4),
                        ),
                        labelText: 'Descriptions',
                        hintText: 'Enter Descriptions',
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
                          constraints: const BoxConstraints.tightFor(width: 300, height: 50),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (Set<MaterialState> states) {
                                  return RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppRadius.r4),
                                  );
                                },
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (widget.liveTrainingModel != null) {
                                  var liveTrainingModel = LiveTrainingModel(
                                    trainerId: widget.liveTrainingModel!.trainerId,
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    trainingDate: DateTime.now(),
                                    startTime: _startTimeController.text,
                                    endTime: _endTimeController.text,
                                  );
                                  liveTrainingAddBloc.add(LiveTrainingAddUpdateButtonPressEvent(liveTrainingModel));
                                } else {
                                  var liveTrainingModel = LiveTrainingModel(
                                    trainerId: sharedPreferences.getInt("user_id")!,
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    trainingDate: DateTime.now(),
                                    startTime: _startTimeController.text,
                                    endTime: _endTimeController.text,
                                  );
                                  liveTrainingAddBloc.add(LiveTrainingAddSaveButtonPressEvent(liveTrainingModel));
                                }
                              }
                            },
                            child: const Text('Save'),
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
      },
    );
  }
}
