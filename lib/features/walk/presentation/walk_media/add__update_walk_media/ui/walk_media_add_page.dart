import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/features/walk/domain/entities/walk_media.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/core/widgets/custom_text_form_field.dart';
import 'package:fitness_app/core/widgets/custom_button.dart';

import '../bloc/walk_media_add_bloc.dart';
import '../bloc/walk_media_add_event.dart';
import '../bloc/walk_media_add_state.dart';
import '../widgets/image_picker_buttons.dart';

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
      walkMediaAddBloc
          .add(WalkMediaAddReadyToUpdateEvent(walkMedia: widget.walkMedia!));
    } else {
      walkMediaAddBloc.add(const WalkMediaAddInitialEvent());
    }
    super.initState();
  }

  final WalkMediaAddBloc walkMediaAddBloc = sl<WalkMediaAddBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
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
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is AddWalkMediaUpdatedState) {
          if (!mounted) return;
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
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppWidth.w30),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppHeight.h30),
                    ImagePickerButtons(
                      onPickGallery: () => walkMediaAddBloc.add(
                        const WalkMediaAddPickFromGalaryButtonPressEvent(),
                      ),
                      onPickCamera: () => walkMediaAddBloc.add(
                        const WalkMediaAddPickFromCameraButtonPressEvent(),
                      ),
                    ),
                    SizedBox(height: AppHeight.h10),
                    CustomTextFormField(
                      label: 'Media URL',
                      controller: walkMediaUrlController,
                      hint: 'description',
                      validator: (v) => (v == null || v.isEmpty) ? '*Required' : null,
                    ),
                    SizedBox(height: AppHeight.h30),
                    CustomButton(
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
                                    updatedWalkMedia: updatedWalkMedia));
                          } else {
                            var newWalkMedia = WalkMedia(
                              walkId: walkId!,
                              userId: userId!,
                              mediaUrl: mediaUrl,
                            );
                            walkMediaAddBloc.add(
                                WalkMediaAddSaveButtonPressEvent(
                                    newWalkMedia: newWalkMedia));
                          }
                        }
                      },
                    ),
                    SizedBox(height: AppHeight.h10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

