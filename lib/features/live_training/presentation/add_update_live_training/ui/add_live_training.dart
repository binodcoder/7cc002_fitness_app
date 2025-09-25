import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
// Use common text field with labels for date/time inputs
import 'package:fitness_app/core/widgets/custom_text_form_field.dart';
import 'package:fitness_app/features/live_training/presentation/add_update_live_training/widgets/title_field.dart';

import 'package:fitness_app/features/login/presentation/widgets/sign_in_button.dart';
import '../bloc/live_training_add_bloc.dart';
import '../bloc/live_training_add_event.dart';
import '../bloc/live_training_add_state.dart';

class AddLiveTrainingDialog extends StatefulWidget {
  final LiveTraining? liveTraining;

  const AddLiveTrainingDialog({
    Key? key,
    this.liveTraining,
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
  final DateFormat _dateFmt = DateFormat('yyyy-MM-dd');
  final _formKey = GlobalKey<FormState>();
  final LiveTrainingAddBloc liveTrainingAddBloc = sl<LiveTrainingAddBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  setDateTime() {
    _dateController.text = _dateFmt.format(selectedDate);
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
    setDateTime();
    if (widget.liveTraining != null) {
      _titleController.text = widget.liveTraining!.title;
      selectedDate = widget.liveTraining!.trainingDate;
      _dateController.text = _dateFmt.format(widget.liveTraining!.trainingDate);
      _startTimeController.text = widget.liveTraining!.startTime;
      _endTimeController.text = widget.liveTraining!.endTime;
      _descriptionController.text = widget.liveTraining!.description;
      // LiveTrainingAddBloc.add(LiveTrainingAddReadyToUpdateEvent(widget.LiveTrainingModel!));
      liveTrainingAddBloc.add(const LiveTrainingAddInitialEvent());
    } else {
      liveTrainingAddBloc.add(const LiveTrainingAddInitialEvent());
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
    liveTrainingAddBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final strings = AppStrings.of(context);
    return BlocConsumer<LiveTrainingAddBloc, LiveTrainingAddState>(
      bloc: liveTrainingAddBloc,
      listenWhen: (previous, current) => current is LiveTrainingAddActionState,
      buildWhen: (previous, current) => current is! LiveTrainingAddActionState,
      listener: (context, state) {
        if (state is LiveTrainingAddLoadingState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state is AddLiveTrainingSavedState) {
          if (!mounted) return;
          // Dismiss loader and close dialog
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is AddLiveTrainingUpdatedState) {
          if (!mounted) return;
          // Dismiss loader and close dialog stack
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is AddLiveTrainingErrorState) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: 'Error while adding training',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
          // Dismiss loader but keep dialog open for user correction
          if (!mounted) return;
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
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
              strings.addLiveTraining,
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
                  TitleField(controller: _titleController),
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
                    label: 'Descriptions',
                    controller: _descriptionController,
                    hint: 'Enter Descriptions',
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
                      final errors = <String>[];
                      if (_titleController.text.trim().isEmpty) {
                        errors.add('Please enter a title.');
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
                          Duration parse(String t) {
                            final parts = t.split(':');
                            final h = int.parse(parts[0]);
                            final m = int.parse(parts[1]);
                            final s =
                                parts.length > 2 ? int.parse(parts[2]) : 0;
                            return Duration(hours: h, minutes: m, seconds: s);
                          }

                          final sd = parse(_startTimeController.text.trim());
                          final ed = parse(_endTimeController.text.trim());
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

                      if (widget.liveTraining != null) {
                        final liveTrainingModel = LiveTraining(
                          trainerId: widget.liveTraining!.trainerId,
                          title: _titleController.text.trim(),
                          description: _descriptionController.text.trim(),
                          trainingDate: selectedDate,
                          startTime: _startTimeController.text,
                          endTime: _endTimeController.text,
                        );
                        liveTrainingAddBloc.add(
                            LiveTrainingAddUpdateButtonPressEvent(
                                liveTraining: liveTrainingModel));
                      } else {
                        final liveTrainingModel = LiveTraining(
                          trainerId: sharedPreferences.getInt("user_id") ?? 1,
                          title: _titleController.text.trim(),
                          description: _descriptionController.text.trim(),
                          trainingDate: selectedDate,
                          startTime: _startTimeController.text,
                          endTime: _endTimeController.text,
                        );
                        liveTrainingAddBloc.add(
                            LiveTrainingAddSaveButtonPressEvent(
                                liveTraining: liveTrainingModel));
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
      },
    );
  }
}
