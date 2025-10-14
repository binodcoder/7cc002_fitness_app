import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/core/widgets/custom_text_form_field.dart';
import 'dart:convert';
import 'package:fitness_app/features/walk/presentation/walk_form/widgets/route_preview.dart';
import 'package:fitness_app/features/walk/presentation/walk_form/ui/route_picker_page.dart';
import 'dart:io';

import 'package:fitness_app/core/widgets/custom_button.dart';
import '../../walk_form/bloc/walk_form_bloc.dart';
import '../../walk_form/bloc/walk_form_event.dart';
import '../../walk_form/bloc/walk_form_state.dart';

class WalkFormPage extends StatefulWidget {
  const WalkFormPage({
    super.key,
    this.walk,
  });

  final Walk? walk;

  @override
  State<WalkFormPage> createState() => _WalkFormPageState();
}

class _WalkFormPageState extends State<WalkFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController routeDataController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController startLocationController = TextEditingController();
  final TextEditingController endLocationController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _routeDataJson;
  // ignore: unused_field
  String? _routeName;

  @override
  void initState() {
    if (widget.walk != null) {
      // If stored as JSON with name+points, display name
      final rd = widget.walk!.routeData;
      try {
        final map = rd.startsWith('{')
            ? (jsonDecode(rd) as Map<String, dynamic>)
            : null;
        if (map != null && map.containsKey('name')) {
          _routeDataJson = rd;
          _routeName = map['name']?.toString() ?? 'Custom Route';
          final start = map['start'] as Map<String, dynamic>?;
          final end = map['end'] as Map<String, dynamic>?;
          if (start != null) {
            startLocationController.text =
                start['name']?.toString() ?? startLocationController.text;
          }
          if (end != null) {
            endLocationController.text =
                end['name']?.toString() ?? endLocationController.text;
          }
        } else {
          _routeName = rd;
        }
      } catch (_) {
        routeDataController.text = rd;
      }
      _selectedDate = widget.walk!.date;
      dateController.text = _formatDate(widget.walk!.date);
      startTimeController.text = widget.walk!.startTime;
      final timeParts = widget.walk!.startTime.split(":");
      if (timeParts.length >= 2) {
        final h = int.tryParse(timeParts[0]) ?? 0;
        final m = int.tryParse(timeParts[1]) ?? 0;
        _selectedTime = TimeOfDay(hour: h, minute: m);
      }
      startLocationController.text = widget.walk!.startLocation;
      walkFormBloc.add(WalkFormReadyToEdit(walk: widget.walk!));
    } else {
      walkFormBloc.add(const WalkFormInitialized());
    }
    super.initState();
  }

  final WalkFormBloc walkFormBloc = sl<WalkFormBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    final strings = AppStrings.of(context);
    return BlocConsumer<WalkFormBloc, WalkFormState>(
      bloc: walkFormBloc,
      listenWhen: (previous, current) => current is WalkFormActionState,
      buildWhen: (previous, current) => current is! WalkFormActionState,
      listener: (context, state) {
        if (state is WalkFormLoading) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state is WalkFormCreateSuccess) {
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is WalkFormUpdateSuccess) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
                widget.walk == null ? strings.addWalk : strings.updateWalk),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: AppHeight.h40,
                      ),
                      // Route card
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: ColorManager.blueGrey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                  onPressed: _openRoutePicker,
                                  child: const Text('Pick on Map')),
                              // Row(
                              //   children: [
                              //     const Icon(Icons.route, color: ColorManager.primary),
                              //     const SizedBox(width: 8),
                              //     Expanded(
                              //       child: Text(
                              //         _routeName ?? 'Select Start and End',
                              //         style: getBoldStyle(
                              //           fontSize: FontSize.s15,
                              //           color: ColorManager.primary,
                              //         ),
                              //         overflow: TextOverflow.ellipsis,
                              //       ),
                              //     ),
                              //     TextButton(onPressed: _openRoutePicker, child: const Text('Pick on Map')),
                              //   ],
                              // ),
                              const SizedBox(height: 6),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                leading: Icon(Icons.place,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                title: const Text('Start'),
                                subtitle: Text(
                                  startLocationController.text.isEmpty
                                      ? 'Tap to set on map'
                                      : startLocationController.text,
                                ),
                                onTap: _openRoutePicker,
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit_location_alt),
                                  onPressed: _openRoutePicker,
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                leading: Icon(Icons.flag,
                                    color: Theme.of(context).colorScheme.error),
                                title: const Text('End'),
                                subtitle: Text(
                                  endLocationController.text.isEmpty
                                      ? 'Tap to set on map'
                                      : endLocationController.text,
                                ),
                                onTap: _openRoutePicker,
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit_location_alt),
                                  onPressed: _openRoutePicker,
                                ),
                              ),
                              if (_routeDataJson != null) ...[
                                const SizedBox(height: 8),
                                RoutePreview(routeJson: _routeDataJson!),
                              ]
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      CustomTextFormField(
                        label: 'Date',
                        controller: dateController,
                        hint: 'Select date',
                        readOnly: true,
                        onTap: _onPickDate,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '*Required' : null,
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      CustomTextFormField(
                        label: 'Start Time',
                        controller: startTimeController,
                        hint: 'Select time',
                        readOnly: true,
                        onTap: _onPickTime,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '*Required' : null,
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      // Start/End are now managed via the Route card above
                      SizedBox(
                        height: AppHeight.h20,
                      ),
                      // Optional image preview
                      state.imagePath != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Selected Image',
                                    style: getBoldStyle(
                                        fontSize: FontSize.s15,
                                        color: ColorManager.primary)),
                                SizedBox(height: AppHeight.h10),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.r10),
                                  child: Image.file(
                                    File(state.imagePath!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => const SizedBox(),
                                  ),
                                ),
                                SizedBox(height: AppHeight.h20),
                              ],
                            )
                          : const SizedBox.shrink(),
                      CustomButton(
                        child: Text(
                          widget.walk == null
                              ? strings.addWalk
                              : strings.updateWalk,
                          style: getRegularStyle(
                            fontSize: FontSize.s16,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          // proposerId may be null if user profile not cached in prefs yet.
                          // Default to 0; Firebase DS will resolve to current user's numeric id.
                          final proposerId =
                              sharedPreferences.getInt("user_id") ?? 0;
                          if (_routeDataJson == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please select Start and End on the map.')),
                            );
                            return;
                          }
                          final routeData = _routeDataJson!;
                          final startLocation = startLocationController.text;
                          final selectedDate = _selectedDate ?? DateTime.now();
                          final startTime = startTimeController.text;
                          if (startTime.isNotEmpty) {
                            if (widget.walk != null) {
                              var updatedWalk = Walk(
                                id: widget.walk!.id,
                                proposerId: proposerId,
                                routeData: routeData,
                                date: selectedDate,
                                startTime: startTime,
                                startLocation: startLocation,
                              );
                              walkFormBloc.add(WalkFormUpdatePressed(
                                  updatedWalk: updatedWalk));
                            } else {
                              var newWalk = Walk(
                                proposerId: proposerId,
                                routeData: routeData,
                                date: selectedDate,
                                startTime: startTime,
                                startLocation: startLocation,
                              );
                              walkFormBloc
                                  .add(WalkFormCreatePressed(newWalk: newWalk));
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onPickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _onPickTime() async {
    final initial = _selectedTime ?? const TimeOfDay(hour: 9, minute: 0);
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        startTimeController.text = _formatTime(picked);
      });
    }
  }

  String _formatDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String _formatTime(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

  @override
  void dispose() {
    routeDataController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    startLocationController.dispose();
    endLocationController.dispose();
    super.dispose();
  }

  Future<void> _openRoutePicker() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => const RoutePickerPage(),
        fullscreenDialog: true,
      ),
    );
    if (result != null && result.isNotEmpty) {
      try {
        final map = jsonDecode(result) as Map<String, dynamic>;
        setState(() {
          _routeDataJson = result;
          _routeName = map['name']?.toString() ?? 'Custom Route';
          final start = map['start'] as Map<String, dynamic>?;
          final end = map['end'] as Map<String, dynamic>?;
          if (start != null) {
            startLocationController.text =
                (start['name']?.toString() ?? startLocationController.text);
          }
          if (end != null) {
            endLocationController.text =
                (end['name']?.toString() ?? endLocationController.text);
          }
        });
      } catch (_) {
        setState(() {
          _routeDataJson = result;
          _routeName = 'Custom Route';
        });
      }
    }
  }
}
