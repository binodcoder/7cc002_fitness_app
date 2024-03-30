import 'package:fitness_app/layers/presentation_layer/walk/ui/walk_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../drawer.dart';
import '../../../../resources/strings_manager.dart';
import '../../appointment/ui/add_appointment.dart';
import '../../register/ui/register_page.dart';
import '../bloc/walk_bloc.dart';
import '../../../../injection_container.dart';
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
              builder: (BuildContext context) => const AddAppointmentDialog(),
              fullscreenDialog: true,
            ),
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
        } else if (state is WalkItemsDeletedActionState) {}
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
                          builder: (BuildContext context) => WalkDetailsPage(
                            walkModel: walkModel,
                          ),
                        ),
                      );
                    },
                    title: Text(walkModel.startLocation),
                    subtitle: Text(walkModel.date.toString()),
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