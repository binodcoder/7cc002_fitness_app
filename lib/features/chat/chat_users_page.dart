import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart' as entity;
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'application/users/bloc/chat_users_bloc.dart';
import 'application/users/bloc/chat_users_event.dart';
import 'application/users/bloc/chat_users_state.dart';
import 'chat_page.dart';

class ChatUsersPage extends StatefulWidget {
  const ChatUsersPage({super.key});

  @override
  State<ChatUsersPage> createState() => _ChatUsersPageState();
}

class _ChatUsersPageState extends State<ChatUsersPage> {
  final ChatUsersBloc _bloc = sl<ChatUsersBloc>();

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        title: const Text('People'),
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
          return ListView.separated(
            itemCount: state.users.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final u = state.users[index];
              final roomId = _roomIdForUsers(myId, u.id ?? 0);
              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('chatRooms')
                    .doc(roomId)
                    .snapshots(),
                builder: (context, snapshot) {
                  String subtitle = u.email;
                  Widget? trailing;
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data()!;
                    final lastText = (data['lastMessageText'] as String?) ?? '';
                    final lastAt =
                        (data['lastMessageAt'] as num?)?.toInt() ?? 0;
                    final lastRead =
                        (data['lastReadAt_$myId'] as num?)?.toInt() ?? 0;
                    final unread = lastAt > lastRead && lastText.isNotEmpty;
                    if (lastText.isNotEmpty) subtitle = lastText;
                    trailing = unread
                        ? const Icon(Icons.brightness_1,
                            color: Colors.red, size: 10)
                        : const Icon(Icons.chevron_right);
                  } else {
                    trailing = const Icon(Icons.chevron_right);
                  }
                  return ListTile(
                    title: Text(u.name),
                    subtitle: Text(subtitle,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: trailing,
                    onTap: () => _openChat(u),
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

  void _openChat(entity.User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatPage(peerUserId: user.id ?? 0, peerName: user.name),
      ),
    );
  }
}
