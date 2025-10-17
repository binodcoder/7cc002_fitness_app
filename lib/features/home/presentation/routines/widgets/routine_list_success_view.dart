import 'package:fitness_app/app/app_router.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/navigation/routes.dart';
import 'package:fitness_app/core/services/profile_guard_service.dart';
import 'package:fitness_app/core/widgets/main_menu_button.dart';
import 'package:fitness_app/core/widgets/user_avatar_action.dart';
import 'package:fitness_app/features/home/presentation/routines/bloc/routine_list_bloc.dart';
import 'package:fitness_app/features/home/presentation/routines/bloc/routine_list_event.dart';
import 'package:fitness_app/features/home/presentation/routines/bloc/routine_list_state.dart';
import 'package:fitness_app/features/home/presentation/routines/widgets/empty_list_view.dart';
import 'package:fitness_app/features/home/presentation/routines/widgets/routine_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutineListSuccessView extends StatelessWidget {
  final RoutineListLoadedSuccessState successState;
  final SharedPreferences sharedPreferences;
  final ProfileGuardService profileGuardService;
  final RoutineListBloc routineListBloc;
  final VoidCallback refreshPage;
  final AppStrings strings;

  const RoutineListSuccessView({
    super.key,
    required this.successState,
    required this.sharedPreferences,
    required this.profileGuardService,
    required this.routineListBloc,
    required this.refreshPage,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final isTrainer = sharedPreferences.getString('role') == "trainer";

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(strings.titleRoutineLabel),
          leading: const MainMenuButton(),
          actions: const [UserAvatarAction()],
        ),
        floatingActionButton: isTrainer
            ? FloatingActionButton(
                heroTag: 'routineFab',
                child: const Icon(Icons.add),
                onPressed: () async {
                  final ok = await profileGuardService.isComplete();
                  if (!ok) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please complete your profile to add a routine.',
                        ),
                      ),
                    );
                    AppRouter.router.push(Routes.profile);
                    return;
                  }
                  routineListBloc.add(
                    const RoutineListAddButtonClickedEvent(),
                  );
                },
              )
            : null,
        body: RefreshIndicator(
          onRefresh: () async {
            refreshPage();
          },
          child: successState.routines.isEmpty
              ? const EmptyListView()
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: successState.routines.length,
                  itemBuilder: (context, index) {
                    final routine = successState.routines[index];
                    return RoutineCard(
                      routine: routine,
                      showOwnerName: !isTrainer,
                      onStart: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Starting ${routine.name}')),
                        );
                      },
                      onAddExercise: isTrainer
                          ? () {
                              routineListBloc.add(
                                RoutineListEditButtonClickedEvent(
                                  routine: routine,
                                ),
                              );
                            }
                          : null,
                      onEdit: isTrainer
                          ? () {
                              routineListBloc.add(
                                RoutineListEditButtonClickedEvent(
                                  routine: routine,
                                ),
                              );
                            }
                          : null,
                      onDelete: isTrainer
                          ? () {
                              routineListBloc.add(
                                RoutineListDeleteButtonClickedEvent(
                                  routine: routine,
                                ),
                              );
                            }
                          : null,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
