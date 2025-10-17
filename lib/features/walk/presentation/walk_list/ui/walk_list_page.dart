import 'package:fitness_app/core/services/profile_guard_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/widgets/user_avatar_action.dart';
import 'package:fitness_app/core/widgets/main_menu_button.dart';
import 'package:fitness_app/features/walk/presentation/walk_form/ui/walk_form_page.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/ui/walk_details_page.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/widgets/walk_card_tile.dart';
import '../../walk_list/bloc/walk_list_bloc.dart';
import '../../walk_list/bloc/walk_list_event.dart';
import '../../walk_list/bloc/walk_list_state.dart';
import 'package:fitness_app/features/profile/presentation/profile_page.dart';

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
        if (state is WalkNavigateToDetailsActionState) {
          // Push on root navigator to hide bottom nav bar
          Navigator.of(context, rootNavigator: true)
              .push(
                MaterialPageRoute(
                  builder: (BuildContext context) => WalkDetailsPage(
                    walk: state.walk,
                  ),
                  fullscreenDialog: true,
                ),
              )
              .then(
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
                appBar: AppBar(
                  backgroundColor: ColorManager.primary,
                  title: Text(strings.titleWalkLabel),
                  leading: const MainMenuButton(),
                  actions: const [UserAvatarAction()],
                ),
                body: ListView.builder(
                  itemCount: successState.walks.length,
                  itemBuilder: (context, index) {
                    final walk = successState.walks[index];
                    final bool isJoined = walk.participants
                        .where((p) => p.id == sharedPreferences.getInt("user_id"))
                        .isNotEmpty;
                    return WalkCardTile(
                      routeData: walk.routeData,
                      startLocation: walk.startLocation,
                      date: walk.date,
                      startTime: walk.startTime,
                      participantCount: walk.participants.length,
                      isJoined: isJoined,
                      onTap: () {
                        // Navigate to details page via BLoC action for consistency
                        walkBloc.add(WalkDetailsRequested(walk: walk));
                      },
                      onJoinTap: () async {
                        final ok = await sl<ProfileGuardService>().isComplete();
                        if (!ok) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please complete your profile to join a walk.')),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfilePage(),
                            ),
                          );
                          return;
                        }
                        final walkParticipant = WalkParticipant(
                          userId: sharedPreferences.getInt("user_id") ?? 0,
                          walkId: walk.id!,
                        );
                        if (isJoined) {
                          walkBloc.add(
                            WalkLeaveRequested(walkParticipant: walkParticipant),
                          );
                        } else {
                          walkBloc.add(
                            WalkJoinRequested(walkParticipant: walkParticipant),
                          );
                        }
                      },
                      onEdit: () {
                        walkBloc.add(WalkEditRequested(walk: walk));
                      },
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
