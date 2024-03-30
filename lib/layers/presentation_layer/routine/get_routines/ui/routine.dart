 import 'package:fitness_app/layers/presentation_layer/routine/get_routines/ui/routine_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/db/db_helper.dart';
import '../../../../../drawer.dart';
import '../../../../../resources/strings_manager.dart';
 import '../../../appointment/add_update_appointment/ui/add_appointment.dart';
import '../../../register/ui/register_page.dart';
import '../bloc/routine_bloc.dart';

import '../../../../../injection_container.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoutineBloc, RoutineState>(
      bloc: postBloc,
      listenWhen: (previous, current) => current is RoutineActionState,
      buildWhen: (previous, current) => current is! RoutineActionState,
      listener: (context, state) {
        if (state is RoutineNavigateToAddRoutineActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AddAppointmentDialog(),
              fullscreenDialog: true,
            ),
          );
        } else if (state is RoutineNavigateToDetailPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => RoutineDetailsPage(
                routineModel: state.routineModel,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is RoutineNavigateToUpdatePageActionState) {
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
            return Scaffold(
              drawer: const MyDrawer(),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add),
                onPressed: () {
                  postBloc.add(RoutineAddButtonClickedEvent());
                },
              ),
              appBar: AppBar(
                title: const Text(AppStrings.titleLabel),
              ),
              body: ListView.builder(
                itemCount: successState.routineModelList.length,
                itemBuilder: (context, index) {
                  var routineModel = successState.routineModelList[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => RoutineDetailsPage(
                            routineModel: routineModel,
                          ),
                        ),
                      );
                    },
                    title: Text(routineModel.source),
                    subtitle: Text(routineModel.description),
                  );
                },
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
