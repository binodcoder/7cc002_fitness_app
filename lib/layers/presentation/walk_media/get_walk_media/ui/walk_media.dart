import 'package:fitness_app/layers/presentation/walk_media/get_walk_media/ui/walk_media_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../../core/db/db_helper.dart';
import '../../../../../drawer.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/strings_manager.dart';
import '../../../appointment/add_update_appointment/ui/add_appointment.dart';
import '../../../register/ui/register_page.dart';
import '../../add__update_walk_media/ui/walk_media_add_page.dart';
import '../bloc/walk_media_bloc.dart';
import '../../../../../injection_container.dart';
import '../bloc/walk_media_event.dart';
import '../bloc/walk_media_state.dart';

class WalkMediaPage extends StatefulWidget {
  final int walkId;
  const WalkMediaPage({super.key, required this.walkId});

  @override
  State<WalkMediaPage> createState() => _WalkMediaPageState();
}

class _WalkMediaPageState extends State<WalkMediaPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();

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
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<WalkMediaBloc, WalkMediaState>(
      bloc: walkMediaBloc,
      listenWhen: (previous, current) => current is WalkMediaActionState,
      buildWhen: (previous, current) => current is! WalkMediaActionState,
      listener: (context, state) {
        if (state is WalkMediaNavigateToAddWalkMediaActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => WalkMediaAddPage(
                walkId: widget.walkId,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is WalkMediaNavigateToDetailPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => WalkMediaDetailsPage(
                walkMediaModel: state.walkMediaModel,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is WalkMediaNavigateToUpdatePageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => WalkMediaAddPage(
                walkMediaModel: state.walkMediaModel,
                walkId: widget.walkId,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is WalkMediaItemSelectedActionState) {
        } else if (state is WalkMediaItemDeletedActionState) {
          walkMediaBloc.add(WalkMediaInitialEvent(widget.walkId));
        } else if (state is WalkMediaItemsDeletedActionState) {}
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case WalkMediaLoadingState:
            return Scaffold(
              backgroundColor: ColorManager.darkWhite,
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          case WalkMediaLoadedSuccessState:
            final successState = state as WalkMediaLoadedSuccessState;
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add),
                onPressed: () {
                  walkMediaBloc.add(WalkMediaAddButtonClickedEvent(successState.walkMediaModelList.first.id!));
                },
              ),
              appBar: AppBar(
                title: const Text(AppStrings.titleWalkMediaLabel),
              ),
              body: ListView.builder(
                itemCount: successState.walkMediaModelList.length,
                itemBuilder: (context, index) {
                  var walkMediaModel = successState.walkMediaModelList[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.46,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            walkMediaBloc.add(WalkMediaEditButtonClickedEvent(walkMediaModel));
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            walkMediaBloc.add(WalkMediaDeleteButtonClickedEvent(walkMediaModel));
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        )
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorManager.white,
                      ),
                      margin: EdgeInsets.all(size.width * 0.02),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => WalkMediaDetailsPage(
                                walkMediaModel: walkMediaModel,
                              ),
                            ),
                          );
                        },
                        title: Text(walkMediaModel.mediaUrl),
                        subtitle: Text(walkMediaModel.userId.toString()),
                      ),
                    ),
                  );
                },
              ),
            );
          case WalkMediaErrorState:
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
