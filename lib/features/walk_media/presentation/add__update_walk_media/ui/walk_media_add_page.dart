import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/features/walk_media/domain/entities/walk_media.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

import 'package:fitness_app/features/login/presentation/widgets/sign_in_button.dart';
import '../bloc/walk_media_add_bloc.dart';
import '../bloc/walk_media_add_event.dart';
import '../bloc/walk_media_add_state.dart';

class WalkMediaAddPage extends StatefulWidget {
  const WalkMediaAddPage({super.key, this.walkMedia, this.walkId});

  final WalkMedia? walkMedia;
  final int? walkId;

  @override
  State<WalkMediaAddPage> createState() => _WalkMediaAddPageState();
}

class _WalkMediaAddPageState extends State<WalkMediaAddPage> {
  final TextEditingController walkMediaUrlController = TextEditingController();

  @override
  void initState() {
    if (widget.walkMedia != null) {
      walkMediaUrlController.text = widget.walkMedia!.mediaUrl;
      walkMediaAddBloc.add(WalkMediaAddReadyToUpdateEvent(widget.walkMedia!));
    } else {
      walkMediaAddBloc.add(WalkMediaAddInitialEvent());
    }
    super.initState();
  }

  final WalkMediaAddBloc walkMediaAddBloc = sl<WalkMediaAddBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final strings = AppStrings.of(context);
    return BlocConsumer<WalkMediaAddBloc, WalkMediaAddState>(
      bloc: walkMediaAddBloc,
      listenWhen: (previous, current) => current is WalkMediaAddActionState,
      buildWhen: (previous, current) => current is! WalkMediaAddActionState,
      listener: (context, state) {
        if (state is AddWalkMediaLoadingState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state is AddWalkMediaSavedState) {
          // sourceController.clear();
          // descriptionController.clear();
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is AddWalkMediaUpdatedState) {
          // sourceController.clear();
          // descriptionController.clear();
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorManager.primary,
            title: Text(widget.walkMedia == null
                ? strings.addWalkMedia
                : strings.updateWalkMedia),
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
                      height: AppHeight.h30,
                    ),
                    _imagePickerButtons(walkMediaAddBloc, context, size),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    TextFormField(
                      controller: walkMediaUrlController,
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
                        hintText: 'description',
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
                      height: AppHeight.h30,
                    ),
                    SigninButton(
                      child: Text(
                        widget.walkMedia == null
                            ? strings.addWalkMedia
                            : strings.updateWalkMedia,
                        style: getRegularStyle(
                          fontSize: FontSize.s16,
                          color: ColorManager.white,
                        ),
                      ),
                      onPressed: () async {
                        var walkId = widget.walkId;
                        var userId = sharedPreferences.getInt("user_id");
                        var mediaUrl = walkMediaUrlController.text;

                        if (mediaUrl.isNotEmpty) {
                          if (widget.walkMedia != null) {
                            var updatedWalkMedia = WalkMedia(
                              id: widget.walkMedia!.id,
                              walkId: walkId!,
                              userId: userId!,
                              mediaUrl: mediaUrl,
                            );
                            walkMediaAddBloc.add(
                                WalkMediaAddUpdateButtonPressEvent(
                                    updatedWalkMedia));
                          } else {
                            var newWalkMedia = WalkMedia(
                              walkId: walkId!,
                              userId: userId!,
                              mediaUrl: mediaUrl,
                            );
                            walkMediaAddBloc.add(
                                WalkMediaAddSaveButtonPressEvent(newWalkMedia));
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

  Widget _imagePickerButtons(
      WalkMediaAddBloc walkMediaAddBloc, BuildContext context, Size size) {
    return Container(
      decoration: BoxDecoration(
          color: ColorManager.redWhite,
          borderRadius: BorderRadius.circular(AppRadius.r10)),
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.all(size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () async {
              walkMediaAddBloc
                  .add(WalkMediaAddPickFromGalaryButtonPressEvent());
            },
            child: Row(
              children: [
                const Icon(
                  Icons.file_copy_outlined,
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 6.0,
                ),
                Text(
                  AppStrings.of(context).pickGalary,
                  style: TextStyle(
                      color: Colors.red[900], fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const Text(
            '|',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          InkWell(
            onTap: () async {
              walkMediaAddBloc
                  .add(WalkMediaAddPickFromCameraButtonPressEvent());
            },
            child: Row(
              children: [
                const Icon(
                  Icons.camera_enhance_outlined,
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 6.0,
                ),
                Text(
                  AppStrings.of(context).camera,
                  style: TextStyle(
                      color: Colors.red[900], fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
