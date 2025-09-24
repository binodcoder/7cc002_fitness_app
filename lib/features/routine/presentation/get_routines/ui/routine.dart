import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/core/db/db_helper.dart';
import 'package:fitness_app/drawer.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/features/routine/presentation/add_update_routine/ui/add_routine_page.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/ui/routine_details.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/widgets/routine_list_tile.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';

import '../bloc/routine_bloc.dart';
import '../bloc/routine_event.dart';
import '../bloc/routine_state.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    postBloc.add(RoutineInitialEvent());
    super.initState();
  }

  void refreshPage() {
    postBloc.add(RoutineInitialEvent());
  }

  RoutineBloc postBloc = sl<RoutineBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return BlocConsumer<RoutineBloc, RoutineState>(
      bloc: postBloc,
      listenWhen: (previous, current) => current is RoutineActionState,
      buildWhen: (previous, current) => current is! RoutineActionState,
      listener: (context, state) {
        if (state is RoutineNavigateToAddRoutineActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AddRoutinePage(),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is RoutineNavigateToDetailPageActionState) {
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
        } else if (state is RoutineNavigateToUpdatePageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddRoutinePage(
                routine: state.routine,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is RoutineItemSelectedActionState) {
        } else if (state is RoutineItemDeletedActionState) {
        } else if (state is RoutineItemsDeletedActionState) {}
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case RoutineLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case RoutineLoadedSuccessState:
            final successState = state as RoutineLoadedSuccessState;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
              ),
              child: Scaffold(
                backgroundColor: ColorManager.darkWhite,
                drawer: const MyDrawer(),
                floatingActionButton:
                    sharedPreferences.getString('role') == "trainer"
                        ? FloatingActionButton(
                            backgroundColor: ColorManager.primary,
                            child: const Icon(Icons.add),
                            onPressed: () {
                              postBloc.add(RoutineAddButtonClickedEvent());
                            },
                          )
                        : null,
                appBar: AppBar(
                  backgroundColor: ColorManager.primary,
                  title: Text(strings.titleRoutineLabel),
                ),
                body: ListView.builder(
                  itemCount: successState.routines.length,
                  itemBuilder: (context, index) {
                    var routine = successState.routines[index];
                    return RoutineListTile(
                      title: routine.name,
                      subtitle: routine.description,
                      trailing: routine.difficulty,
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
                        postBloc.add(
                          RoutineEditButtonClickedEvent(routine),
                        );
                      },
                      onDelete: () {},
                    );
                  },
                ),
              ),
            );
          case RoutineErrorState:
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
