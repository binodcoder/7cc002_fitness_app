import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/features/profile/infrastructure/services/profile_guard.dart';
import 'package:fitness_app/features/walk/domain/usecases/join_walk.dart';
import 'package:fitness_app/features/walk/domain/usecases/leave_walk.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/widgets/walk_details_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/walk/presentation/walk_media/walk_media_list/bloc/walk_media_bloc.dart';
import 'package:fitness_app/features/walk/presentation/walk_media/walk_media_list/bloc/walk_media_event.dart';
import 'package:fitness_app/features/walk/presentation/walk_media/walk_media_form/ui/walk_media_form_page.dart';

class WalkDetailsPage extends StatefulWidget {
  const WalkDetailsPage({
    Key? key,
    this.walk,
  }) : super(key: key);

  final Walk? walk;

  @override
  State<WalkDetailsPage> createState() => _WalkDetailsPageState();
}

class _WalkDetailsPageState extends State<WalkDetailsPage> {
  late Walk _walk;
  late List<Participant> _participants;
  late SharedPreferences _prefs;
  bool _busy = false;
  late WalkMediaBloc _mediaBloc;

  @override
  void initState() {
    _walk = widget.walk!;
    _participants =
        List<Participant>.from(widget.walk?.participants ?? const []);
    _prefs = sl<SharedPreferences>();
    _mediaBloc = sl<WalkMediaBloc>();
    if (_walk.id != null) {
      _mediaBloc.add(WalkMediaInitialEvent(_walk.id!));
    }
    super.initState();
  }

  @override
  void dispose() {
    _mediaBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isJoined = _isJoined();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: ColorManager.primary,
          ),
        ),
        backgroundColor: ColorManager.white,
        elevation: 0,
        title: const Text('Walk Details',
            style: TextStyle(
              color: ColorManager.primary,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        actions: [
          if (_walk.id != null)
            IconButton(
              tooltip: 'Add Photo',
              onPressed: _onAddMedia,
              icon: const Icon(
                Icons.add_a_photo_outlined,
                color: ColorManager.primary,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _busy
                ? const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    onPressed: _onJoinOrLeavePressed,
                    child: Text(
                      isJoined ? 'Leave' : 'Join',
                      style: const TextStyle(
                        color: ColorManager.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _mediaBloc,
        child: WalkDetailsBody(
          walk: _walk,
          participants: _participants,
          proposerName: _computeProposerName(),
          walkId: _walk.id,
        ),
      ),
    );
  }

  int _currentUserId() => _prefs.getInt("user_id") ?? 0;

  bool _isJoined() {
    final uid = _currentUserId();
    return _participants.any((p) => p.id == uid);
  }

  String _computeProposerName() {
    final p = _participants.where((e) => e.id == _walk.proposerId).toList();
    if (p.isNotEmpty && p.first.name.isNotEmpty) return p.first.name;
    return 'User #${_walk.proposerId}';
  }

  Future<void> _onJoinOrLeavePressed() async {
    final ok = await sl<ProfileGuardService>().isComplete();
    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete your profile first.')),
      );
      return;
    }
    if (_walk.id == null) return;

    setState(() => _busy = true);
    try {
      final uid = _currentUserId();
      final wp = WalkParticipant(userId: uid, walkId: _walk.id!);
      if (_isJoined()) {
        final res = await sl<LeaveWalk>()(wp);
        res?.fold(
          (f) => _showError('Failed to leave walk'),
          (_) {
            setState(() {
              _participants.removeWhere((e) => e.id == uid);
            });
            _showSnack('You left this walk');
          },
        );
      } else {
        final res = await sl<JoinWalk>()(wp);
        res?.fold(
          (f) => _showError('Failed to join walk'),
          (_) {
            setState(() {
              _participants.add(
                Participant(
                  id: uid,
                  name: 'You',
                  email: '',
                  password: '',
                  institutionEmail: '',
                  gender: '',
                  age: 0,
                  role: 'standard',
                ),
              );
            });
            _showSnack('You joined this walk');
          },
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _onAddMedia() async {
    if (_walk.id == null) return;
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => WalkMediaAddPage(walkId: _walk.id!),
        fullscreenDialog: true,
      ),
    );
    if (!mounted) return;
    _mediaBloc.add(WalkMediaInitialEvent(_walk.id!));
  }
}
