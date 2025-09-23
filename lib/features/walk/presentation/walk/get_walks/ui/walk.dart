import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/core/db/db_helper.dart';
import 'package:fitness_app/features/walk/data/models/walk_participant_model.dart';
import 'package:fitness_app/drawer.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/features/walk/presentation/walk/add_update_walk/ui/walk_add_page.dart';
import 'package:fitness_app/features/walk/presentation/walk/get_walks/ui/walk_details.dart';
import 'package:fitness_app/features/walk_media/presentation/get_walk_media/ui/walk_media.dart';

import '../bloc/walk_bloc.dart';
import '../bloc/walk_event.dart';
import '../bloc/walk_state.dart';

class WalkPage extends StatefulWidget {
  const WalkPage({super.key});

  @override
  State<WalkPage> createState() => _WalkPageState();
}

class _WalkPageState extends State<WalkPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    walkBloc.add(WalkInitialEvent());
    super.initState();
  }

  void refreshPage() {
    walkBloc.add(WalkInitialEvent());
  }

  WalkBloc walkBloc = sl<WalkBloc>();
  SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final strings = AppStrings.of(context);
    return BlocConsumer<WalkBloc, WalkState>(
      bloc: walkBloc,
      listenWhen: (previous, current) => current is WalkActionState,
      buildWhen: (previous, current) => current is! WalkActionState,
      listener: (context, state) {
        if (state is WalkNavigateToAddWalkActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AddWalkPage(),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is WalkNavigateToDetailPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => WalkDetailsPage(
                walkModel: state.walkModel,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is WalkNavigateToUpdatePageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  AddWalkPage(walkModel: state.walkModel),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is WalkItemSelectedActionState) {
        } else if (state is WalkItemDeletedActionState) {
        } else if (state is WalkItemsDeletedActionState) {
        } else if (state is WalkJoinedActionState) {
          walkBloc.add(WalkInitialEvent());
        } else if (state is WalkLeftActionState) {
          walkBloc.add(WalkInitialEvent());
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case WalkLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case WalkLoadedSuccessState:
            final successState = state as WalkLoadedSuccessState;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
              ),
              child: Scaffold(
                backgroundColor: ColorManager.darkWhite,
                drawer: const MyDrawer(),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: ColorManager.primary,
                  child: const Icon(Icons.add),
                  onPressed: () {
                    walkBloc.add(WalkAddButtonClickedEvent());
                  },
                ),
                appBar: AppBar(
                  backgroundColor: ColorManager.primary,
                  title: Text(strings.titleWalkLabel),
                ),
                body: ListView.builder(
                  itemCount: successState.walkModelList.length,
                  itemBuilder: (context, index) {
                    var walkModel = successState.walkModelList[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.46,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              walkBloc
                                  .add(WalkEditButtonClickedEvent(walkModel));
                            },
                            backgroundColor: const Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context) {},
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
                                builder: (BuildContext context) =>
                                    WalkMediaPage(
                                  walkId: successState.walkModelList[index].id!,
                                ),
                              ),
                            );
                          },
                          title: Text(walkModel.startLocation),
                          subtitle: Text(
                              "${DateFormat("yMd").format(walkModel.date)} ${walkModel.startTime}"),
                          trailing: TextButton(
                            onPressed: () {
                              WalkParticipantModel walkParticipantModel =
                                  WalkParticipantModel(
                                userId: sharedPreferences.getInt("user_id")!,
                                walkId: walkModel.id!,
                              );
                              if (walkModel.participants!
                                  .where((element) =>
                                      element.id ==
                                      sharedPreferences.getInt("user_id"))
                                  .isNotEmpty) {
                                walkBloc.add(WalkLeaveButtonClickedEvent(
                                    walkParticipantModel));
                              } else {
                                walkBloc.add(WalkJoinButtonClickedEvent(
                                    walkParticipantModel));
                              }
                            },
                            child: Text(
                              (walkModel.participants!
                                      .where((element) =>
                                          element.id ==
                                          sharedPreferences.getInt("user_id"))
                                      .isNotEmpty)
                                  ? 'Leave'
                                  : 'Join',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          case WalkErrorState:
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
