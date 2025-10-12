import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/features/live_training/presentation/add_update_live_training/ui/add_live_training.dart';
import 'package:fitness_app/features/live_training/presentation/get_live_trainings/ui/live_training_details.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/app/app_router.dart';
import 'package:fitness_app/core/navigation/routes.dart';

import '../bloc/live_training_bloc.dart';
import '../bloc/live_training_event.dart';
import '../bloc/live_training_state.dart';
import 'package:fitness_app/features/live_training/presentation/get_live_trainings/widgets/live_training_list_tile.dart';

class LiveTrainingPage extends StatefulWidget {
  const LiveTrainingPage({super.key});

  @override
  State<LiveTrainingPage> createState() => _LiveTrainingPageState();
}

class _LiveTrainingPageState extends State<LiveTrainingPage> {
  @override
  void initState() {
    liveTrainingBloc.add(const LiveTrainingInitialEvent());
    super.initState();
  }

  void refreshPage() {
    liveTrainingBloc.add(const LiveTrainingInitialEvent());
  }

  LiveTrainingBloc liveTrainingBloc = sl<LiveTrainingBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return BlocConsumer<LiveTrainingBloc, LiveTrainingState>(
      bloc: liveTrainingBloc,
      listenWhen: (previous, current) => current is LiveTrainingActionState,
      buildWhen: (previous, current) => current is! LiveTrainingActionState,
      listener: (context, state) {
        if (state is LiveTrainingNavigateToAddLiveTrainingActionState) {
          if (!mounted) return;
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
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LiveTrainingDetailsPage(
                liveTraining: state.liveTraining,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is LiveTrainingNavigateToUpdatePageActionState) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddLiveTrainingDialog(
                liveTraining: state.liveTraining,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is LiveTrainingItemDeletedActionState) {
          liveTrainingBloc.add(const LiveTrainingInitialEvent());
        } else if (state is LiveTrainingItemsDeletedActionState) {
        } else if (state is LiveTrainingShowErrorActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
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
              floatingActionButton:
                  sharedPreferences.getString('role') == "trainer"
                      ? FloatingActionButton(
                          heroTag: 'liveTrainingFab',
                          backgroundColor: ColorManager.primary,
                          child: const Icon(Icons.add),
                          onPressed: () {
                            liveTrainingBloc
                                .add(const LiveTrainingAddButtonClickedEvent());
                          },
                        )
                      : null,
              appBar: AppBar(
                backgroundColor: ColorManager.primary,
                title: Text(strings.titleLiveTrainingLabel),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    final nav = Navigator.of(context);
                    if (nav.canPop()) {
                      nav.pop();
                    } else {
                      AppRouter.router.go(Routes.routineRoute);
                    }
                  },
                ),
              ),
              body: ListView.builder(
                itemCount: successState.liveTrainings.length,
                itemBuilder: (context, index) {
                  var liveTraining = successState.liveTrainings[index];
                  return LiveTrainingListTile(
                    title: liveTraining.title,
                    subtitle: liveTraining.description,
                    onTap: () {
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LiveTrainingDetailsPage(
                            liveTraining: liveTraining,
                          ),
                        ),
                      );
                    },
                    onEdit: () {
                      liveTrainingBloc.add(
                        LiveTrainingEditButtonClickedEvent(
                            liveTraining: liveTraining),
                      );
                    },
                    onDelete: () {
                      liveTrainingBloc.add(
                        LiveTrainingDeleteButtonClickedEvent(
                            liveTraining: liveTraining),
                      );
                    },
                  );
                },
              ),
            );
          case LiveTrainingErrorState:
            final error = state as LiveTrainingErrorState;
            return Scaffold(body: Center(child: Text(error.message)));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
