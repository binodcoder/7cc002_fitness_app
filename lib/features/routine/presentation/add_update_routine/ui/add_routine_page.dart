import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:fitness_app/features/routine/data/models/routine_model.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

import 'package:fitness_app/features/login/presentation/widgets/sign_in_button.dart';
import '../bloc/routine_add_bloc.dart';
import '../bloc/routine_add_event.dart';
import '../bloc/routine_add_state.dart';

class AddRoutinePage extends StatefulWidget {
  const AddRoutinePage({
    super.key,
    this.routineModel,
  });

  final RoutineModel? routineModel;

  @override
  State<AddRoutinePage> createState() => _AddRoutinePageState();
}

class _AddRoutinePageState extends State<AddRoutinePage> {
  final TextEditingController routineNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController difficultyController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();

  @override
  void initState() {
    if (widget.routineModel != null) {
      routineNameController.text = widget.routineModel!.name;
      descriptionController.text = widget.routineModel!.description;
      difficultyController.text = widget.routineModel!.difficulty;
      durationController.text = widget.routineModel!.duration.toString();
      sourceController.text = widget.routineModel!.source;
      routineAddBloc.add(RoutineAddReadyToUpdateEvent(widget.routineModel!));
    } else {
      routineAddBloc.add(RoutineAddInitialEvent());
    }
    super.initState();
  }

  final RoutineAddBloc routineAddBloc = sl<RoutineAddBloc>();

  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    final strings = AppStrings.of(context);
    return BlocConsumer<RoutineAddBloc, RoutineAddState>(
      bloc: routineAddBloc,
      listenWhen: (previous, current) => current is RoutineAddActionState,
      buildWhen: (previous, current) => current is! RoutineAddActionState,
      listener: (context, state) {
        if (state is AddRoutineLoadingState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state is AddRoutineSavedActionState) {
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is AddRoutineUpdatedActionState) {
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is AddRoutineErrorState) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: 'Error while adding routine',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
          Navigator.pop(context);
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
              title: Text(strings.addRoutine),
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
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      Text(
                        "RoutineName",
                        style: getBoldStyle(
                          fontSize: FontSize.s15,
                          color: ColorManager.primary,
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      TextFormField(
                        controller: routineNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: ColorManager.redWhite,
                          filled: true,
                          hintText: 'Routine Name',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.blueGrey),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.primary),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.red),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      Text(
                        "Description",
                        style: getBoldStyle(
                          fontSize: FontSize.s15,
                          color: ColorManager.primary,
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: ColorManager.redWhite,
                          filled: true,
                          hintText: 'Description',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.blueGrey),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.primary),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.red),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      Text(
                        "Difficulty",
                        style: getBoldStyle(
                          fontSize: FontSize.s15,
                          color: ColorManager.primary,
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      TextFormField(
                        controller: difficultyController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: ColorManager.redWhite,
                          filled: true,
                          hintText: 'Difficulty',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.blueGrey),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.primary),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.red),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      Text(
                        "Duration",
                        style: getBoldStyle(
                          fontSize: FontSize.s15,
                          color: ColorManager.primary,
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      TextFormField(
                        controller: durationController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: ColorManager.redWhite,
                          filled: true,
                          hintText: 'Duration',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.blueGrey),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.primary),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.red),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      Text(
                        "Source",
                        style: getBoldStyle(
                          fontSize: FontSize.s15,
                          color: ColorManager.primary,
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      TextFormField(
                        controller: sourceController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: ColorManager.redWhite,
                          filled: true,
                          hintText: 'Source',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.blueGrey),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.primary),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorManager.red),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      SizedBox(
                        height: AppHeight.h30,
                      ),
                      SigninButton(
                        child: Text(
                          widget.routineModel == null
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
                            if (widget.routineModel != null) {
                              var updatedRoutine = RoutineModel(
                                id: widget.routineModel!.id,
                                name: routineName,
                                description: description,
                                difficulty: difficulty,
                                duration: int.parse(duration),
                                source: source,
                              );
                              routineAddBloc.add(
                                  RoutineAddUpdateButtonPressEvent(
                                      updatedRoutine));
                            } else {
                              var newRoutine = RoutineModel(
                                name: routineName,
                                description: description,
                                difficulty: difficulty,
                                duration: int.parse(duration),
                                source: source,
                              );
                              routineAddBloc.add(
                                  RoutineAddSaveButtonPressEvent(newRoutine));
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
