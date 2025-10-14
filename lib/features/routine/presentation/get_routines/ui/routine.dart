import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/features/routine/presentation/routine_form/ui/routine_form_page.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/ui/routine_details.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/widgets/routine_list_tile.dart';
import 'package:fitness_app/core/widgets/user_avatar_action.dart';
import 'package:fitness_app/core/widgets/main_menu_button.dart';

import '../bloc/routine_list_bloc.dart';
import '../bloc/routine_list_event.dart';
import '../bloc/routine_list_state.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  @override
  void initState() {
    _boot();
    super.initState();
  }

  Future<void> _boot() async {
    if (mounted) {
      listBloc.add(const RoutineListInitialEvent());
    }
  }

  void refreshPage() {
    listBloc.add(const RoutineListInitialEvent());
  }

  RoutineListBloc listBloc = sl<RoutineListBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return BlocConsumer<RoutineListBloc, RoutineListState>(
      bloc: listBloc,
      listenWhen: (previous, current) => current is RoutineListActionState,
      buildWhen: (previous, current) => current is! RoutineListActionState,
      listener: (context, state) {
        if (state is RoutineListNavigateToAddRoutineActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const RoutineFormPage(),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is RoutineListNavigateToDetailPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => RoutineDetailsPage(
                routine: state.routine,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is RoutineListNavigateToUpdatePageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => RoutineFormPage(
                routine: state.routine,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is RoutineListItemSelectedActionState) {
        } else if (state is RoutineListItemDeletedActionState) {
        } else if (state is RoutineListItemsDeletedActionState) {}
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case RoutineListLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case RoutineListLoadedSuccessState:
            final successState = state as RoutineListLoadedSuccessState;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
              ),
              child: Scaffold(
                floatingActionButton: sharedPreferences.getString('role') ==
                        "trainer"
                    ? FloatingActionButton(
                        heroTag: 'routineFab',
                        child: const Icon(Icons.add),
                        onPressed: () {
                          listBloc
                              .add(const RoutineListAddButtonClickedEvent());
                        },
                      )
                    : null,
                appBar: AppBar(
                  title: Text(strings.titleRoutineLabel),
                  leading: const MainMenuButton(),
                  actions: const [UserAvatarAction()],
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    refreshPage();
                  },
                  child: successState.routines.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 200),
                            Center(child: Text('No routines available')),
                          ],
                        )
                      : ListView.builder(
                          itemCount: successState.routines.length,
                          itemBuilder: (context, index) {
                            var routine = successState.routines[index];
                            return RoutineListTile(
                              title: routine.name,
                              description: routine.description,
                              difficulty: routine.difficulty,
                              durationMinutes: routine.duration,
                              source: routine.source,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        RoutineDetailsPage(
                                      routine: routine,
                                    ),
                                  ),
                                );
                              },
                              onEdit: () {
                                listBloc.add(
                                  RoutineListEditButtonClickedEvent(
                                      routine: routine),
                                );
                              },
                              onDelete: () {},
                            );
                          },
                        ),
                ),
              ),
            );
          case RoutineListErrorState:
            final error = state as RoutineListErrorState;
            return Scaffold(body: Center(child: Text(error.message)));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
