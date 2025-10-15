import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/features/walk/domain/entities/walk_media.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/core/widgets/custom_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:firebase_core/firebase_core.dart' as fcore;
import 'package:fitness_app/firebase_options.dart';
import 'package:path/path.dart' as p;
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
  String? _lastUploadedPath;
  bool _uploading = false;
  String? _uploadedUrl;

  @override
  void initState() {
    if (widget.walkMedia != null) {
      walkMediaUrlController.text = widget.walkMedia!.mediaUrl;
      walkMediaAddBloc
          .add(WalkMediaAddReadyToUpdateEvent(walkMedia: widget.walkMedia!));
    } else {
      walkMediaAddBloc.add(const WalkMediaAddInitialEvent());
    }
    walkMediaUrlController.addListener(() {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    walkMediaUrlController.dispose();
    super.dispose();
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
        // For now, we don't auto-upload; users paste a URL manually.
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
                    // Users provide a URL directly for now.
                    Text(
                      'Paste image or video URL',
                      style: getRegularStyle(
                        fontSize: FontSize.s16,
                        color: ColorManager.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: walkMediaUrlController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'https://...jpg',
                        labelText: 'Media URL',
                        suffixIcon: IconButton(
                          tooltip: 'Paste from clipboard',
                          icon: const Icon(Icons.paste),
                          onPressed: () async {
                            final data =
                                await Clipboard.getData(Clipboard.kTextPlain);
                            final text = data?.text?.trim();
                            if (text != null && text.isNotEmpty) {
                              if (mounted) {
                                setState(() {
                                  walkMediaUrlController.text = text;
                                });
                              }
                            }
                          },
                        ),
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 12),
                    if ((walkMediaUrlController.text).isNotEmpty ||
                        _uploadedUrl != null) ...[
                      _MediaPreview(
                        localPath: null,
                        remoteUrl: walkMediaUrlController.text.isNotEmpty
                            ? walkMediaUrlController.text
                            : _uploadedUrl,
                      ),
                      const SizedBox(height: 12),
                    ],
                    SizedBox(height: AppHeight.h10),
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
                        var userId = sharedPreferences.getInt("user_id") ?? 0;
                        var mediaUrl = walkMediaUrlController.text;

                        if (mediaUrl.isNotEmpty) {
                          if (widget.walkMedia != null) {
                            var updatedWalkMedia = WalkMedia(
                              id: widget.walkMedia!.id,
                              walkId: walkId!,
                              userId: userId,
                              mediaUrl: mediaUrl,
                            );
                            walkMediaAddBloc.add(
                                WalkMediaAddUpdateButtonPressEvent(
                                    updatedWalkMedia: updatedWalkMedia));
                          } else {
                            var newWalkMedia = WalkMedia(
                              walkId: walkId!,
                              userId: userId,
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

  Future<void> _uploadAndSetUrl(String imagePath) async {
    try {
      setState(() {
        _uploading = true;
        _lastUploadedPath = imagePath;
      });
      // Ensure Firebase is initialized (in case REST backend is selected)
      if (fcore.Firebase.apps.isEmpty) {
        await fcore.Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      final walkId = widget.walkId ?? 0;
      final file = File(imagePath);
      final ext = p.extension(imagePath).replaceAll('.', '');
      final ts = DateTime.now().millisecondsSinceEpoch;
      final ref = fstorage.FirebaseStorage.instance
          .ref()
          .child('walks/$walkId/media_$ts.${ext.isEmpty ? 'jpg' : ext}');
      final task = await ref.putFile(file);
      final url = await task.ref.getDownloadURL();
      if (!mounted) return;
      setState(() {
        _uploadedUrl = url;
        _uploading = false;
      });
      walkMediaUrlController.text = url;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _uploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload failed')),
      );
    }
  }
}

bool _isImagePathOrUrl(String pathOrUrl) {
  final p = pathOrUrl.toLowerCase();
  return p.endsWith('.jpg') ||
      p.endsWith('.jpeg') ||
      p.endsWith('.png') ||
      p.endsWith('.gif') ||
      p.endsWith('.webp');
}

class _MediaPreview extends StatelessWidget {
  final String? localPath;
  final String? remoteUrl;
  const _MediaPreview({required this.localPath, required this.remoteUrl});

  @override
  Widget build(BuildContext context) {
    final isRemote = (remoteUrl ?? '').isNotEmpty;
    final target = isRemote ? remoteUrl! : (localPath ?? '');
    final isImage = _isImagePathOrUrl(target);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: isImage
            ? (isRemote
                ? Image.network(
                    target,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image)),
                  )
                : Image.file(
                    File(target),
                    fit: BoxFit.cover,
                  ))
            : Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: Icon(Icons.videocam, size: 48),
                ),
              ),
      ),
    );
  }
}
