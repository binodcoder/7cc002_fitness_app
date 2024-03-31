import 'package:fitness_app/core/model/walk_participant_model.dart';
import 'package:fitness_app/layers/presentation/walk/add_update_walk/ui/walk_add_page.dart';
import 'package:fitness_app/layers/presentation/walk/get_walks/ui/walk_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/db/db_helper.dart';
import '../../../../../drawer.dart';
import '../../../../../resources/strings_manager.dart';
import '../../../appointment/add_update_appointment/ui/add_appointment.dart';
import '../../../walk_media/get_walk_media/ui/walk_media.dart';
import '../bloc/walk_bloc.dart';
import '../../../../../injection_container.dart';
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
            return Scaffold(
              drawer: const MyDrawer(),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add),
                onPressed: () {
                  walkBloc.add(WalkAddButtonClickedEvent());
                },
              ),
              appBar: AppBar(
                title: const Text(AppStrings.titleLabel),
              ),
              body: ListView.builder(
                itemCount: successState.walkModelList.length,
                itemBuilder: (context, index) {
                  var walkModel = successState.walkModelList[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => WalkMediaPage(
                            walkId: successState.walkModelList[index].id!,
                          ),
                        ),
                      );
                    },
                    title: Text(walkModel.startLocation),
                    subtitle: Text(walkModel.date.toString()),
                    trailing: TextButton(
                      onPressed: () {
                        WalkParticipantModel walkParticipantModel = WalkParticipantModel(
                          userId: sharedPreferences.getInt("user_id")!,
                          walkId: walkModel.id!,
                        );
                        if (walkModel.participants!.where((element) => element.id == sharedPreferences.getInt("user_id")).isNotEmpty) {
                          walkBloc.add(WalkLeaveButtonClickedEvent(walkParticipantModel));
                        } else {
                          walkBloc.add(WalkJoinButtonClickedEvent(walkParticipantModel));
                        }
                      },
                      child: Text(
                        (walkModel.participants!.where((element) => element.id == sharedPreferences.getInt("user_id")).isNotEmpty) ? 'Leave' : 'Join',
                      ),
                    ),
                  );
                },
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
