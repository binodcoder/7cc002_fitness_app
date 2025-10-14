import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/features/walk/presentation/walk_media/get_walk_media/ui/walk_media_details.dart';

import '../../add__update_walk_media/ui/walk_media_add_page.dart';
import '../bloc/walk_media_bloc.dart';
import '../bloc/walk_media_event.dart';
import '../bloc/walk_media_state.dart';
import 'package:fitness_app/core/widgets/app_slidable_list_tile.dart';

class WalkMediaPage extends StatefulWidget {
  final int walkId;
  const WalkMediaPage({super.key, required this.walkId});

  @override
  State<WalkMediaPage> createState() => _WalkMediaPageState();
}

class _WalkMediaPageState extends State<WalkMediaPage> {
  @override
  void initState() {
    walkMediaBloc.add(WalkMediaInitialEvent(widget.walkId));
    super.initState();
  }

  void refreshPage() {
    walkMediaBloc.add(WalkMediaInitialEvent(widget.walkId));
  }

  WalkMediaBloc walkMediaBloc = sl<WalkMediaBloc>();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return BlocConsumer<WalkMediaBloc, WalkMediaState>(
      bloc: walkMediaBloc,
      listenWhen: (previous, current) => current is WalkMediaActionState,
      buildWhen: (previous, current) => current is! WalkMediaActionState,
      listener: (context, state) {
        if (state is WalkMediaNavigateToAddWalkMediaActionState) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => WalkMediaAddPage(
                walkId: widget.walkId,
              ),
              fullscreenDialog: true,
            ),
          ).then((value) => refreshPage());
        } else if (state is WalkMediaNavigateToDetailPageActionState) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => WalkMediaDetailsPage(
                walkMedia: state.walkMedia,
              ),
              fullscreenDialog: true,
            ),
          ).then((value) => refreshPage());
        } else if (state is WalkMediaNavigateToUpdatePageActionState) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => WalkMediaAddPage(
                walkMedia: state.walkMedia,
                walkId: widget.walkId,
              ),
              fullscreenDialog: true,
            ),
          ).then((value) => refreshPage());
        } else if (state is WalkMediaItemSelectedActionState) {
        } else if (state is WalkMediaItemDeletedActionState) {
          walkMediaBloc.add(WalkMediaInitialEvent(widget.walkId));
        } else if (state is WalkMediaShowErrorActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case WalkMediaLoadingState:
            return const Scaffold(
              backgroundColor: ColorManager.darkWhite,
              body: Center(child: CircularProgressIndicator()),
            );
          case WalkMediaLoadedSuccessState:
            final successState = state as WalkMediaLoadedSuccessState;
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: ColorManager.primary,
                child: const Icon(Icons.add),
                onPressed: () {
                  // Pass the current walkId to the add page
                  walkMediaBloc
                      .add(WalkMediaAddButtonClickedEvent(widget.walkId));
                },
              ),
              appBar: AppBar(
                backgroundColor: ColorManager.primary,
                title: Text(strings.titleWalkMediaLabel),
              ),
              body: ListView.builder(
                itemCount: successState.walkMediaList.length,
                itemBuilder: (context, index) {
                  var walkMedia = successState.walkMediaList[index];
                  final isNetwork = walkMedia.mediaUrl.startsWith('http');
                  bool isImageUrl(String url) {
                    final p = url.toLowerCase();
                    return p.endsWith('.jpg') ||
                        p.endsWith('.jpeg') ||
                        p.endsWith('.png') ||
                        p.endsWith('.gif') ||
                        p.endsWith('.webp');
                  }

                  return AppSlidableListTile(
                    title: 'Media #${walkMedia.id ?? (index + 1)}',
                    subtitle: 'By user ${walkMedia.userId}',
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: isNetwork && isImageUrl(walkMedia.mediaUrl)
                            ? Image.network(
                                walkMedia.mediaUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image),
                              )
                            : Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                child: Icon(
                                  isNetwork ? Icons.videocam : Icons.image,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                      ),
                    ),
                    onTap: () {
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              WalkMediaDetailsPage(walkMedia: walkMedia),
                        ),
                      );
                    },
                    onEdit: () {
                      walkMediaBloc.add(
                        WalkMediaEditButtonClickedEvent(walkMedia),
                      );
                    },
                    onDelete: () {
                      walkMediaBloc.add(
                        WalkMediaDeleteButtonClickedEvent(walkMedia),
                      );
                    },
                  );
                },
              ),
            );
          case WalkMediaErrorState:
            final error = state as WalkMediaErrorState;
            return Scaffold(body: Center(child: Text(error.message)));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
