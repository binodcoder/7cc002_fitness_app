import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'application/chat/chat_bloc.dart';
import 'application/chat/chat_event.dart';
import 'application/chat/chat_state.dart';
import 'domain/usecases/mark_room_read.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.peerUserId, this.peerName, this.fixedRoomId});

  final int? peerUserId;
  final String? peerName;
  final String? fixedRoomId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatBloc _bloc = sl<ChatBloc>();
  final SessionManager _session = sl<SessionManager>();
  final TextEditingController _textController = TextEditingController();
  late final String _roomId;
  late final String _userId;

  @override
  void initState() {
    super.initState();
    final myId = _session.getCurrentUser()?.id ?? 0;
    _userId = myId.toString();
    if (widget.fixedRoomId != null && widget.fixedRoomId!.isNotEmpty) {
      _roomId = widget.fixedRoomId!;
    } else if (widget.peerUserId != null) {
      final a = myId;
      final b = widget.peerUserId!;
      final low = a <= b ? a : b;
      final high = a <= b ? b : a;
      _roomId = 'dm_${low}_$high';
    } else {
      _roomId = 'global';
    }
    _bloc.add(ChatStarted(_roomId));
    // Mark as read on open
    sl<MarkRoomRead>()(MarkRoomReadParams(roomId: _roomId, userId: _userId));
  }

  @override
  void dispose() {
    _textController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.peerName ?? 'Chat')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state.loading && state.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final m = state.messages[index];
                    final isMe = m.authorId == _userId;
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              isMe ? Colors.blueAccent : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.text,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatTime(m.createdAt),
                              style: TextStyle(
                                fontSize: 11,
                                color: isMe
                                    ? Colors.white70
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = _textController.text.trim();
                    if (text.isEmpty) return;
                    _bloc.add(ChatSendPressed(
                        roomId: _roomId, authorId: _userId, text: text));
                    _textController.clear();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
