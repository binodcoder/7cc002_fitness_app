import 'package:fitness_app/app/app_router.dart';
import 'package:fitness_app/core/navigation/routes.dart';
import 'package:fitness_app/features/home/presentation/routines/widgets/routine_list_error_view.dart';
import 'package:fitness_app/features/home/presentation/routines/widgets/routine_list_loading_view.dart';
import 'package:fitness_app/features/home/presentation/routines/widgets/routine_list_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/features/profile/infrastructure/services/profile_guard.dart';
import '../bloc/routine_list_bloc.dart';
import '../bloc/routine_list_event.dart';
import '../bloc/routine_list_state.dart';

class RoutineListPage extends StatefulWidget {
  const RoutineListPage({super.key});

  @override
  State<RoutineListPage> createState() => _RoutineListPageState();
}

class _RoutineListPageState extends State<RoutineListPage> {
  @override
  void initState() {
    _boot();
    super.initState();
  }

  Future<void> _boot() async {
    if (mounted) {
      routineListBloc.add(const RoutineListInitialEvent());
    }
  }

  void refreshPage() {
    routineListBloc.add(const RoutineListInitialEvent());
  }

  final RoutineListBloc routineListBloc = sl<RoutineListBloc>();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();
  final ProfileGuardService profileGuardService = sl<ProfileGuardService>();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return BlocConsumer<RoutineListBloc, RoutineListState>(
      bloc: routineListBloc,
      listenWhen: (previous, current) => current is RoutineListActionState,
      buildWhen: (previous, current) => current is! RoutineListActionState,
      listener: (context, state) {
        if (state is RoutineListNavigateToAddRoutineActionState) {
          AppRouter.router.push(Routes.routineForm).then((_) => refreshPage());
        } else if (state is RoutineListNavigateToDetailPageActionState) {
        } else if (state is RoutineListNavigateToUpdatePageActionState) {
          AppRouter.router
              .push(Routes.updateRoutineForm, extra: state.routine)
              .then((_) => refreshPage());
        } else if (state is RoutineListItemSelectedActionState) {
        } else if (state is RoutineListItemDeletedActionState) {
        } else if (state is RoutineListItemsDeletedActionState) {}
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case RoutineListLoadingState:
            return const RoutineListLoadingView();
          case RoutineListLoadedSuccessState:
            return RoutineListSuccessView(
              successState: state as RoutineListLoadedSuccessState,
              sharedPreferences: sharedPreferences,
              profileGuardService: profileGuardService,
              routineListBloc: routineListBloc,
              refreshPage: refreshPage,
              strings: strings,
            );
          case RoutineListErrorState:
            return RoutineListErrorView(error: state as RoutineListErrorState);
          default:
            return const SizedBox();
        }
      },
    );
  }
}
