import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import '../../../../../core/db/db_helper.dart';
import '../../../../../drawer.dart';
import '../../../../../resources/strings_manager.dart';
import '../../../appointment/add_update_appointment/ui/add_appointment.dart';
import '../../../register/ui/register_page.dart';
import '../../../../../injection_container.dart';
import '../../add_update_live_training/ui/add_live_training.dart';
import '../bloc/live_training_bloc.dart';
import '../bloc/live_training_event.dart';
import '../bloc/live_training_state.dart';
import 'live_training_details.dart';

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

  @override
  Widget build(BuildContext context) {
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
              drawer: const MyDrawer(),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add),
                onPressed: () {
                  liveTrainingBloc.add(LiveTrainingAddButtonClickedEvent());
                },
              ),
              appBar: AppBar(
                title: const Text(AppStrings.titleLiveTrainingLabel),
              ),
              body: ListView.builder(
                itemCount: successState.liveTrainingModels.length,
                itemBuilder: (context, index) {
                  var liveTrainingModel = successState.liveTrainingModels[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.46,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            liveTrainingBloc.add(LiveTrainingEditButtonClickedEvent(liveTrainingModel));
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            liveTrainingBloc.add(LiveTrainingDeleteButtonClickedEvent(liveTrainingModel));
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        )
                      ],
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => LiveTrainingDetailsPage(
                              liveTrainingModel: liveTrainingModel,
                            ),
                          ),
                        );
                      },
                      title: Text(liveTrainingModel.title),
                      subtitle: Text(liveTrainingModel.description),
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
