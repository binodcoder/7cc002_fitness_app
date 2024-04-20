import 'package:fitness_app/layers/presentation/routine/add_update_routine/ui/add_routine_page.dart';
import 'package:fitness_app/layers/presentation/routine/get_routines/ui/routine_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../../core/db/db_helper.dart';
import '../../../../../drawer.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/strings_manager.dart';
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
    Size size = MediaQuery.of(context).size;

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
                routineModel: state.routineModel,
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
                routineModel: state.routineModel,
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
            return Scaffold(
              backgroundColor: ColorManager.darkWhite,
              drawer: const MyDrawer(),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add),
                onPressed: () {
                  postBloc.add(RoutineAddButtonClickedEvent());
                },
              ),
              appBar: AppBar(
                title: const Text(AppStrings.titleRoutineLabel),
              ),
              body: ListView.builder(
                itemCount: successState.routineModelList.length,
                itemBuilder: (context, index) {
                  var routineModel = successState.routineModelList[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.46,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            postBloc.add(RoutineEditButtonClickedEvent(routineModel));
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
                              builder: (BuildContext context) => RoutineDetailsPage(
                                routineModel: routineModel,
                              ),
                            ),
                          );
                        },
                        title: Text(routineModel.name),
                        subtitle: Text(routineModel.description),
                        trailing: Text(routineModel.difficulty),
                        isThreeLine: true,
                      ),
                    ),
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
