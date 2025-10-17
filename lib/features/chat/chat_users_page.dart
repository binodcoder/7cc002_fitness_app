import 'package:fitness_app/core/widgets/main_menu_button.dart';
import 'package:fitness_app/core/widgets/user_avatar_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart' as entity;
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'application/users/chat_users_bloc.dart';
import 'application/users/chat_users_event.dart';
import 'application/users/chat_users_state.dart';
import 'chat_page.dart';
import 'package:fitness_app/core/widgets/app_list_tile.dart';
import 'package:fitness_app/features/profile/infrastructure/services/profile_guard.dart';
import 'package:fitness_app/features/profile/presentation/profile_page.dart';

class _ProfileInfo {
  final String name;
  final String photoUrl;
  const _ProfileInfo({required this.name, required this.photoUrl});
}

class ChatUsersPage extends StatefulWidget {
  const ChatUsersPage({super.key});

  @override
  State<ChatUsersPage> createState() => _ChatUsersPageState();
}

class _ChatUsersPageState extends State<ChatUsersPage> {
  final ChatUsersBloc _bloc = sl<ChatUsersBloc>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, _ProfileInfo> _profileByEmail = {};
  final Map<String, Future<_ProfileInfo>> _pendingProfileByEmail = {};

  @override
  void initState() {
    super.initState();
    _bloc.add(const ChatUsersRequested());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
        leading: const MainMenuButton(),
        actions: const [UserAvatarAction()],
      ),
      body: BlocBuilder<ChatUsersBloc, ChatUsersState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }
          if (state.users.isEmpty) {
            return const Center(child: Text('No users found'));
          }
          final myId = sl<SessionManager>().getCurrentUser()?.id ?? 0;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final u = state.users[index];
              final roomId = _roomIdForUsers(myId, u.id ?? 0);

              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream:
                    _firestore.collection('chatRooms').doc(roomId).snapshots(),
                builder: (context, snapshot) {
                  String lastMessage = '';
                  bool unread = false;
                  String lastTime = '';
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data()!;
                    final lastText = (data['lastMessageText'] as String?) ?? '';
                    final lastAt =
                        (data['lastMessageAt'] as num?)?.toInt() ?? 0;
                    final lastRead =
                        (data['lastReadAt_$myId'] as num?)?.toInt() ?? 0;
                    lastMessage = lastText;
                    unread = lastAt > lastRead && lastText.isNotEmpty;
                    lastTime = _formatHmFromMillis(lastAt);
                  }

                  return FutureBuilder<_ProfileInfo>(
                    future: _getProfileByEmail(u.email),
                    builder: (context, profSnap) {
                      final prof = profSnap.data;
                      final displayName = (prof?.name.isNotEmpty == true)
                          ? prof!.name
                          : u.email;
                      final photoUrl = prof?.photoUrl ?? '';

                      return _ChatUserTile(
                        name: displayName,
                        email: u.email,
                        photoUrl: photoUrl,
                        lastMessage:
                            lastMessage.isNotEmpty ? lastMessage : u.email,
                        meta: lastTime,
                        unread: unread,
                        onTap: () async {
                          final ok =
                              await sl<ProfileGuardService>().isComplete();
                          if (!ok) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please complete your profile to send messages.')),
                            );
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (_) => const ProfilePage(),
                              ),
                            );
                            return;
                          }
                          _openChatWithName(u, displayName);
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _roomIdForUsers(int a, int b) {
    final low = a <= b ? a : b;
    final high = a <= b ? b : a;
    return 'dm_${low}_$high';
  }

  void _openChatWithName(entity.User user, String name) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => ChatPage(peerUserId: user.id ?? 0, peerName: name),
      ),
    );
  }

  Future<_ProfileInfo> _getProfileByEmail(String email) async {
    if (_profileByEmail.containsKey(email)) return _profileByEmail[email]!;
    final pending = _pendingProfileByEmail[email];
    if (pending != null) return pending;

    final fut = _loadProfileByEmail(email);
    _pendingProfileByEmail[email] = fut;
    final res = await fut;
    _profileByEmail[email] = res;
    _pendingProfileByEmail.remove(email);
    return res;
  }

  Future<_ProfileInfo> _loadProfileByEmail(String email) async {
    try {
      // Find user doc by email to get UID
      final users = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (users.docs.isEmpty) {
        return const _ProfileInfo(name: '', photoUrl: '');
      }
      final uid = users.docs.first.id;
      final prof = await _firestore.collection('profiles').doc(uid).get();
      final data = prof.data() ?? {};
      final name = (data['name'] as String?)?.trim() ?? '';
      final photo = (data['photoUrl'] as String?)?.trim() ?? '';
      return _ProfileInfo(name: name, photoUrl: photo);
    } catch (_) {
      return const _ProfileInfo(name: '', photoUrl: '');
    }
  }
}

class _ChatUserTile extends StatelessWidget {
  final String name;
  final String email;
  final String photoUrl;
  final String lastMessage;
  final String? meta; // e.g., HH:mm for last message time
  final bool unread;
  final VoidCallback onTap;

  const _ChatUserTile({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.lastMessage,
    this.meta,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final title = name.isNotEmpty ? name : email;
    return AppListTile(
      leading: _buildAvatar(context, scheme),
      title: title,
      subtitle: lastMessage.isNotEmpty ? lastMessage : email,
      trailing: (meta != null && meta!.isNotEmpty) || unread
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (meta != null && meta!.isNotEmpty)
                  Text(
                    meta!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                const SizedBox(height: 6),
                unread
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: scheme.error,
                          shape: BoxShape.circle,
                        ),
                      )
                    : Icon(Icons.chevron_right,
                        size: 18, color: scheme.onSurfaceVariant),
              ],
            )
          : Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
      onTap: onTap,
    );
  }

  Widget _buildAvatar(BuildContext context, ColorScheme scheme) {
    if (photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(photoUrl),
        backgroundColor: scheme.surfaceContainerHighest,
      );
    }
    final initial = (name.isNotEmpty ? name : email).trim().isNotEmpty
        ? (name.isNotEmpty ? name : email).trim()[0].toUpperCase()
        : '?';
    return CircleAvatar(
      radius: 22,
      backgroundColor: scheme.primary.withValues(alpha: 0.15),
      child: Text(
        initial,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

String _formatHmFromMillis(int millis) {
  if (millis <= 0) return '';
  final dt = DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true).toLocal();
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
