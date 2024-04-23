import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/model/walk_media_model.dart';
import '../../../../../injection_container.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/font_manager.dart';
import '../../../../../resources/strings_manager.dart';
import '../../../../../resources/styles_manager.dart';
import '../../../../../resources/values_manager.dart';
import '../../../login/widgets/sign_in_button.dart';
import '../bloc/walk_media_add_bloc.dart';
import '../bloc/walk_media_add_event.dart';
import '../bloc/walk_media_add_state.dart';

class WalkMediaAddPage extends StatefulWidget {
  const WalkMediaAddPage({super.key, this.walkMediaModel, this.walkId});

  final WalkMediaModel? walkMediaModel;
  final int? walkId;

  @override
  State<WalkMediaAddPage> createState() => _WalkMediaAddPageState();
}

class _WalkMediaAddPageState extends State<WalkMediaAddPage> {
  final TextEditingController walkMediaUrlController = TextEditingController();

  @override
  void initState() {
    if (widget.walkMediaModel != null) {
      walkMediaUrlController.text = widget.walkMediaModel!.mediaUrl;
      walkMediaAddBloc.add(WalkMediaAddReadyToUpdateEvent(widget.walkMediaModel!));
    } else {
      walkMediaAddBloc.add(WalkMediaAddInitialEvent());
    }
    super.initState();
  }

  final WalkMediaAddBloc walkMediaAddBloc = sl<WalkMediaAddBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<WalkMediaAddBloc, WalkMediaAddState>(
      bloc: walkMediaAddBloc,
      listenWhen: (previous, current) => current is WalkMediaAddActionState,
      buildWhen: (previous, current) => current is! WalkMediaAddActionState,
      listener: (context, state) {
        if (state is AddWalkMediaSavedState) {
          // sourceController.clear();
          // descriptionController.clear();
          Navigator.pop(context);
        } else if (state is AddWalkMediaUpdatedState) {
          // sourceController.clear();
          // descriptionController.clear();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorManager.primary,
            title: const Text(AppStrings.addWalkMedia),
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
                      "Walk Media Url",
                      style: getBoldStyle(
                        fontSize: FontSize.s15,
                        color: ColorManager.primary,
                      ),
                    ),
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
                        hintText: 'WalkMedia Name',
                        suffixIcon: Icon(
                          Icons.person,
                          color: ColorManager.blue,
                          size: FontSize.s20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.blueGrey),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.primary),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.red),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h30,
                    ),
                    SigninButton(
                      child: Text(
                        widget.walkMediaModel == null ? AppStrings.addWalkMedia : AppStrings.updateWalkMedia,
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
                          if (widget.walkMediaModel != null) {
                            var updatedWalkMedia = WalkMediaModel(
                              id: widget.walkMediaModel!.id,
                              walkId: walkId!,
                              userId: userId!,
                              mediaUrl: mediaUrl,
                            );
                            walkMediaAddBloc.add(WalkMediaAddUpdateButtonPressEvent(updatedWalkMedia));
                          } else {
                            var newWalkMedia = WalkMediaModel(
                              walkId: walkId!,
                              userId: userId!,
                              mediaUrl: mediaUrl,
                            );
                            walkMediaAddBloc.add(WalkMediaAddSaveButtonPressEvent(newWalkMedia));
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
