import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/core/db/db_helper.dart';
import 'package:fitness_app/core/model/walk_model.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

import 'package:fitness_app/features/login/presentation/login/widgets/sign_in_button.dart';
import '../bloc/walk_add_bloc.dart';
import '../bloc/walk_add_event.dart';
import '../bloc/walk_add_state.dart';

class AddWalkPage extends StatefulWidget {
  const AddWalkPage({
    super.key,
    this.walkModel,
  });

  final WalkModel? walkModel;

  @override
  State<AddWalkPage> createState() => _AddWalkPageState();
}

class _AddWalkPageState extends State<AddWalkPage> {
  final TextEditingController routeDataController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController startLocationController = TextEditingController();

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    if (widget.walkModel != null) {
      routeDataController.text = widget.walkModel!.routeData;
      dateController.text = widget.walkModel!.date.toString();
      startTimeController.text = widget.walkModel!.startTime;
      startLocationController.text = widget.walkModel!.startLocation;
      walkAddBloc.add(WalkAddReadyToUpdateEvent(widget.walkModel!));
    } else {
      walkAddBloc.add(WalkAddInitialEvent());
    }
    super.initState();
  }

  final WalkAddBloc walkAddBloc = sl<WalkAddBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    final strings = AppStrings.of(context);
    return BlocConsumer<WalkAddBloc, WalkAddState>(
      bloc: walkAddBloc,
      listenWhen: (previous, current) => current is WalkAddActionState,
      buildWhen: (previous, current) => current is! WalkAddActionState,
      listener: (context, state) {
        if (state is AddWalkLoadingState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state is AddWalkSavedState) {
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is AddWalkUpdatedState) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorManager.primary,
            title: Text(widget.walkModel == null
                ? strings.addWalk
                : strings.updateWalk),
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
                      height: AppHeight.h40,
                    ),
                    Text(
                      "Route Data",
                      style: getBoldStyle(
                        fontSize: FontSize.s15,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    TextFormField(
                      controller: routeDataController,
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
                        hintText: 'Route Data',
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
                          borderSide: const BorderSide(color: ColorManager.red),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    Text(
                      "Date",
                      style: getBoldStyle(
                        fontSize: FontSize.s15,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    TextFormField(
                      controller: dateController,
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
                        hintText: 'Date',
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
                          borderSide: const BorderSide(color: ColorManager.red),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    Text(
                      "Start Time",
                      style: getBoldStyle(
                        fontSize: FontSize.s15,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    TextFormField(
                      controller: startTimeController,
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
                        hintText: 'Start Time',
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
                          borderSide: const BorderSide(color: ColorManager.red),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    Text(
                      "Start Location",
                      style: getBoldStyle(
                        fontSize: FontSize.s15,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    TextFormField(
                      controller: startLocationController,
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
                        hintText: 'Start Location',
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
                          borderSide: const BorderSide(color: ColorManager.red),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h20,
                    ),
                    SigninButton(
                      child: Text(
                        widget.walkModel == null
                            ? strings.addWalk
                            : strings.updateWalk,
                        style: getRegularStyle(
                          fontSize: FontSize.s16,
                          color: ColorManager.white,
                        ),
                      ),
                      onPressed: () async {
                        var proposerId = sharedPreferences.getInt("user_id");
                        var routeData = routeDataController.text;
                        var date = dateController.text;
                        var startTime = startTimeController.text;
                        var startLocation = startLocationController.text;
                        if (date.isNotEmpty && startLocation.isNotEmpty) {
                          if (widget.walkModel != null) {
                            var updatedWalk = WalkModel(
                              id: widget.walkModel!.id,
                              proposerId: proposerId!,
                              routeData: routeData,
                              date: DateTime.now(),
                              startTime: startTime,
                              startLocation: startLocation,
                            );
                            walkAddBloc.add(
                                WalkAddUpdateButtonPressEvent(updatedWalk));
                          } else {
                            var newWalk = WalkModel(
                              proposerId: proposerId!,
                              routeData: routeData,
                              date: DateTime.now(),
                              startTime: startTime,
                              startLocation: startLocation,
                            );
                            walkAddBloc
                                .add(WalkAddSaveButtonPressEvent(newWalk));
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
        );
      },
    );
  }
}
