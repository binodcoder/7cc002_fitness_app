import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/app/drawer.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/features/walk/presentation/walk_form/ui/walk_form_page.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/ui/walk_details_page.dart';
import 'package:fitness_app/features/walk/presentation/walk_media/get_walk_media/ui/walk_media.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/widgets/walk_list_tile.dart';

import '../../walk_list/bloc/walk_list_bloc.dart';
import '../../walk_list/bloc/walk_list_event.dart';
import '../../walk_list/bloc/walk_list_state.dart';

class WalkListPage extends StatefulWidget {
  const WalkListPage({super.key});

  @override
  State<WalkListPage> createState() => _WalkListPageState();
}

class _WalkListPageState extends State<WalkListPage> {
  @override
  void initState() {
    walkBloc.add(const WalkListInitialized());
    super.initState();
  }

  void refreshPage() {
    walkBloc.add(const WalkListInitialized());
  }

  WalkListBloc walkBloc = sl<WalkListBloc>();
  SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return BlocConsumer<WalkListBloc, WalkListState>(
      bloc: walkBloc,
      listenWhen: (previous, current) => current is WalkListActionState,
      buildWhen: (previous, current) => current is! WalkListActionState,
      listener: (context, state) {
        if (state is WalkNavigateToCreateActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const WalkFormPage(),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is WalkNavigateToDetailsActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => WalkDetailsPage(
                walk: state.walk,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is WalkNavigateToEditActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => WalkFormPage(walk: state.walk),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is WalkItemSelectedActionState) {
        } else if (state is WalkItemDeletedActionState) {
        } else if (state is WalkItemsDeletedActionState) {
        } else if (state is WalkJoinedActionState) {
          walkBloc.add(const WalkListInitialized());
        } else if (state is WalkLeftActionState) {
          walkBloc.add(const WalkListInitialized());
        } else if (state is WalkListShowErrorActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case WalkListLoading:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case WalkListLoaded:
            final successState = state as WalkListLoaded;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
              ),
              child: Scaffold(
                backgroundColor: ColorManager.darkWhite,
                drawer: const MyDrawer(),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: ColorManager.primary,
                  child: const Icon(Icons.add),
                  onPressed: () {
                    walkBloc.add(const WalkCreateRequested());
                  },
                ),
                appBar: AppBar(
                  backgroundColor: ColorManager.primary,
                  title: Text(strings.titleWalkLabel),
                ),
                body: ListView.builder(
                  itemCount: successState.walks.length,
                  itemBuilder: (context, index) {
                    var walk = successState.walks[index];
                    final bool isJoined = walk.participants
                        .where((element) =>
                            element.id == sharedPreferences.getInt("user_id"))
                        .isNotEmpty;
                    return WalkListTile(
                      title: walk.startLocation,
                      subtitle:
                          "${DateFormat("yMd").format(walk.date)} ${walk.startTime}",
                      isJoined: isJoined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => WalkMediaPage(
                              walkId: successState.walks[index].id!,
                            ),
                          ),
                        );
                      },
                      onJoinTap: () {
                        WalkParticipant walkParticipant = WalkParticipant(
                          // If not cached yet, pass 0; Firebase DS will resolve current user id
                          userId: sharedPreferences.getInt("user_id") ?? 0,
                          walkId: walk.id!,
                        );
                        if (isJoined) {
                          walkBloc.add(WalkLeaveRequested(
                              walkParticipant: walkParticipant));
                        } else {
                          walkBloc.add(WalkJoinRequested(
                              walkParticipant: walkParticipant));
                        }
                      },
                      onEdit: () {
                        walkBloc.add(WalkEditRequested(walk: walk));
                      },
                      onDelete: () {},
                    );
                  },
                ),
              ),
            );
          case WalkListError:
            final error = state as WalkListError;
            return Scaffold(body: Center(child: Text(error.message)));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
