import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/features/walk/presentation/walk_form/ui/walk_form_page.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/ui/walk_details_page.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/widgets/walk_card_tile.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/bloc/walk_list_bloc.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/bloc/walk_list_event.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/bloc/walk_list_state.dart';

class MyWalksPage extends StatefulWidget {
  const MyWalksPage({super.key});

  @override
  State<MyWalksPage> createState() => _MyWalksPageState();
}

class _MyWalksPageState extends State<MyWalksPage> {
  final WalkListBloc _bloc = sl<WalkListBloc>();
  final SharedPreferences _prefs = sl<SharedPreferences>();

  @override
  void initState() {
    super.initState();
    _bloc.add(const WalkListInitialized());
  }

  int get _currentUserId => _prefs.getInt('user_id') ?? 0;

  void _refresh() => _bloc.add(const WalkListInitialized());

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalkListBloc, WalkListState>(
      bloc: _bloc,
      listenWhen: (prev, curr) => curr is WalkListActionState,
      buildWhen: (prev, curr) => curr is! WalkListActionState,
      listener: (context, state) {
        if (state is WalkListShowErrorActionState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is WalkListLoading) {
          return const Scaffold(
            appBar: _MyAppBar(),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is WalkListError) {
          return Scaffold(
              appBar: const _MyAppBar(), body: Center(child: Text(state.message)));
        }
        final walks = (state is WalkListLoaded) ? state.walks : <Walk>[];
        final myWalks = walks.where((w) => w.proposerId == _currentUserId).toList();

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          child: Scaffold(
            backgroundColor: ColorManager.darkWhite,
            appBar: const _MyAppBar(),
            floatingActionButton: FloatingActionButton(
              heroTag: 'myWalkFab',
              backgroundColor: ColorManager.primary,
              child: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => const WalkFormPage(),
                    fullscreenDialog: true,
                  ),
                );
                _refresh();
              },
            ),
            body: myWalks.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    itemCount: myWalks.length,
                    itemBuilder: (context, index) {
                      final walk = myWalks[index];
                      return WalkCardTile(
                        routeData: walk.routeData,
                        startLocation: walk.startLocation,
                        date: walk.date,
                        startTime: walk.startTime,
                        participantCount: walk.participants.length,
                        isJoined: true, // irrelevant when actions displayed
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => WalkDetailsPage(walk: walk),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        showJoinButton: false,
                        onEdit: () async {
                          await Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => WalkFormPage(walk: walk),
                              fullscreenDialog: true,
                            ),
                          );
                          _refresh();
                        },
                        onDelete: () async {
                          final confirmed = await _confirmDelete(context);
                          if (confirmed) {
                            _bloc.add(WalkDeleteRequested(walk: walk));
                          }
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete walk?'),
            content: const Text('This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MyAppBar();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Walks'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.directions_walk, size: 56, color: Colors.grey),
            SizedBox(height: 12),
            Text('No walks yet'),
            SizedBox(height: 4),
            Text('Use the + button to create your first walk.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

