import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/core/widgets/custom_button.dart';
import 'package:fitness_app/core/widgets/custom_text_form_field.dart';
import '../bloc/routine_form_bloc.dart';
import '../bloc/routine_form_event.dart';
import '../bloc/routine_form_state.dart';

class RoutineFormPage extends StatefulWidget {
  const RoutineFormPage({
    super.key,
    this.routine,
  });

  final Routine? routine;

  @override
  State<RoutineFormPage> createState() => _RoutineFormPageState();
}

class _RoutineFormPageState extends State<RoutineFormPage> {
  final TextEditingController routineNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController difficultyController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();

  @override
  void initState() {
    if (widget.routine != null) {
      routineNameController.text = widget.routine!.name;
      descriptionController.text = widget.routine!.description;
      difficultyController.text = widget.routine!.difficulty;
      durationController.text = widget.routine!.duration.toString();
      sourceController.text = widget.routine!.source;
      routineFormBloc
          .add(RoutineFormReadyToUpdateEvent(routine: widget.routine!));
    } else {
      routineFormBloc.add(const RoutineFormInitialEvent());
    }
    super.initState();
  }

  final RoutineFormBloc routineFormBloc = sl<RoutineFormBloc>();

  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    final strings = AppStrings.of(context);
    return BlocConsumer<RoutineFormBloc, RoutineFormState>(
      bloc: routineFormBloc,
      listenWhen: (previous, current) => current is RoutineFormActionState,
      buildWhen: (previous, current) => current is! RoutineFormActionState,
      listener: (context, state) {
        if (state is RoutineFormLoadingState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state is RoutineFormSavedActionState) {
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is RoutineFormUpdatedActionState) {
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is RoutineFormErrorState) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: 'Error while adding routine',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
          if (!mounted) return;
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorManager.primary,
              title: Text(
                widget.routine == null
                    ? strings.addRoutine
                    : strings.updateRoutine,
              ),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.w30),
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: BorderRadius.circular(
                      AppRadius.r20,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppHeight.h10),
                      CustomTextFormField(
                        label: 'RoutineName',
                        controller: routineNameController,
                        hint: 'Routine Name',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '*Required' : null,
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      CustomTextFormField(
                        label: 'Description',
                        controller: descriptionController,
                        hint: 'Description',
                        minLines: 3,
                        maxLines: 5,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '*Required' : null,
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      CustomTextFormField(
                        label: 'Difficulty',
                        controller: difficultyController,
                        hint: 'Difficulty',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '*Required' : null,
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      CustomTextFormField(
                        label: 'Duration',
                        controller: durationController,
                        hint: 'Duration (minutes)',
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '*Required' : null,
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      CustomTextFormField(
                        label: 'Source',
                        controller: sourceController,
                        hint: 'Source',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '*Required' : null,
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      SizedBox(
                        height: AppHeight.h30,
                      ),
                      CustomButton(
                        child: Text(
                          widget.routine == null
                              ? strings.addRoutine
                              : strings.updateRoutine,
                          style: getRegularStyle(
                            fontSize: FontSize.s16,
                            color: ColorManager.white,
                          ),
                        ),
                        onPressed: () async {
                          var routineName = routineNameController.text;
                          var description = descriptionController.text;
                          var difficulty = difficultyController.text;
                          var duration = durationController.text;
                          var source = sourceController.text;
                          if (routineName.isNotEmpty && duration.isNotEmpty) {
                            if (widget.routine != null) {
                              var updatedRoutine = Routine(
                                id: widget.routine!.id,
                                name: routineName,
                                description: description,
                                difficulty: difficulty,
                                duration: int.parse(duration),
                                source: source,
                              );
                              routineFormBloc.add(
                                  RoutineFormUpdateButtonPressEvent(
                                      updatedRoutine: updatedRoutine));
                            } else {
                              var newRoutine = Routine(
                                name: routineName,
                                description: description,
                                difficulty: difficulty,
                                duration: int.parse(duration),
                                source: source,
                              );
                              routineFormBloc.add(
                                  RoutineFormSaveButtonPressEvent(
                                      newRoutine: newRoutine));
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                    ],
                  ),
                  // ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
