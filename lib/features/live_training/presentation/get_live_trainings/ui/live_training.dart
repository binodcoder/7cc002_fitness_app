import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/core/db/db_helper.dart';
import 'package:fitness_app/drawer.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/features/live_training/presentation/add_update_live_training/ui/add_live_training.dart';
import 'package:fitness_app/features/live_training/presentation/get_live_trainings/ui/live_training_details.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';

import '../bloc/live_training_bloc.dart';
import '../bloc/live_training_event.dart';
import '../bloc/live_training_state.dart';

class LiveTrainingPage extends StatefulWidget {
  const LiveTrainingPage({super.key});

  @override
  State<LiveTrainingPage> createState() => _LiveTrainingPageState();
}

class _LiveTrainingPageState extends State<LiveTrainingPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    liveTrainingBloc.add(LiveTrainingInitialEvent());
    super.initState();
  }

  void refreshPage() {
    liveTrainingBloc.add(LiveTrainingInitialEvent());
  }

  LiveTrainingBloc liveTrainingBloc = sl<LiveTrainingBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final strings = AppStrings.of(context);
    return BlocConsumer<LiveTrainingBloc, LiveTrainingState>(
      bloc: liveTrainingBloc,
      listenWhen: (previous, current) => current is LiveTrainingActionState,
      buildWhen: (previous, current) => current is! LiveTrainingActionState,
      listener: (context, state) {
        if (state is LiveTrainingNavigateToAddLiveTrainingActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AddLiveTrainingDialog(),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is LiveTrainingNavigateToDetailPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LiveTrainingDetailsPage(
                liveTrainingModel: state.liveTrainingModel,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is LiveTrainingNavigateToUpdatePageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddLiveTrainingDialog(
                liveTrainingModel: state.liveTrainingModel,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is LiveTrainingItemDeletedActionState) {
          liveTrainingBloc.add(LiveTrainingInitialEvent());
        } else if (state is LiveTrainingItemsDeletedActionState) {}
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case LiveTrainingLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case LiveTrainingLoadedSuccessState:
            final successState = state as LiveTrainingLoadedSuccessState;
            return Scaffold(
              backgroundColor: ColorManager.darkWhite,
              drawer: const MyDrawer(),
              floatingActionButton:
                  sharedPreferences.getString('role') == "trainer"
                      ? FloatingActionButton(
                          backgroundColor: ColorManager.primary,
                          child: const Icon(Icons.add),
                          onPressed: () {
                            liveTrainingBloc
                                .add(LiveTrainingAddButtonClickedEvent());
                          },
                        )
                      : null,
              appBar: AppBar(
                backgroundColor: ColorManager.primary,
                title: Text(strings.titleLiveTrainingLabel),
              ),
              body: ListView.builder(
                itemCount: successState.liveTrainingModels.length,
                itemBuilder: (context, index) {
                  var liveTrainingModel =
                      successState.liveTrainingModels[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.46,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            liveTrainingBloc.add(
                                LiveTrainingEditButtonClickedEvent(
                                    liveTrainingModel));
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            liveTrainingBloc.add(
                                LiveTrainingDeleteButtonClickedEvent(
                                    liveTrainingModel));
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
                              builder: (BuildContext context) =>
                                  LiveTrainingDetailsPage(
                                liveTrainingModel: liveTrainingModel,
                              ),
                            ),
                          );
                        },
                        title: Text(liveTrainingModel.title),
                        subtitle: Text(liveTrainingModel.description),
                      ),
                    ),
                  );
                },
              ),
            );
          case LiveTrainingErrorState:
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
