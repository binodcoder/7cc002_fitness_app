import 'package:fitness_app/core/services/profile_guard_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/core/services/session_manager.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'application/chat/chat_bloc.dart';
import 'application/chat/chat_event.dart';
import 'application/chat/chat_state.dart';
import 'domain/usecases/mark_room_read.dart';
import 'package:fitness_app/features/profile/presentation/profile_page.dart';

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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
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
                final msgs = state.messages;
                return ListView.builder(
                  reverse: true,
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    final m = msgs[index];
                    final isMe = m.authorId == _userId;
                    final showHeader = index == 0
                        ? true
                        : !_isSameDate(msgs[index].createdAt, msgs[index - 1].createdAt);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showHeader) ...[
                          const SizedBox(height: 8),
                          _DayHeader(label: _formatDayLabel(m.createdAt)),
                          const SizedBox(height: 4),
                        ],
                        Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color:
                                  isMe ? scheme.primary : scheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m.text,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: isMe ? scheme.onPrimary : scheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _formatTime(m.createdAt),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: isMe
                                        ? scheme.onPrimary.withValues(alpha: 0.85)
                                        : scheme.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                  onPressed: () async {
                    final text = _textController.text.trim();
                    if (text.isEmpty) return;
                    final ok = await sl<ProfileGuardService>().isComplete();
                    if (!ok) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please complete your profile to send messages.')),
                      );
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (_) => const ProfilePage(),
                        ),
                      );
                      return;
                    }
                    _bloc.add(
                        ChatSendPressed(roomId: _roomId, authorId: _userId, text: text));
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

  bool _isSameDate(DateTime a, DateTime b) {
    final al = a.toLocal();
    final bl = b.toLocal();
    return al.year == bl.year && al.month == bl.month && al.day == bl.day;
  }

  String _formatDayLabel(DateTime dt) {
    final d = dt.toLocal();
    final now = DateTime.now();
    DateTime only(DateTime x) => DateTime(x.year, x.month, x.day);
    final today = only(now);
    final date = only(d);
    final diff = date.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == -1) return 'Yesterday';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final mm = months[date.month - 1];
    final yyyy = date.year.toString();
    final dd = date.day.toString().padLeft(2, '0');
    final sameYear = date.year == today.year;
    return sameYear ? '$dd $mm' : '$dd $mm $yyyy';
  }
}

class _DayHeader extends StatelessWidget {
  final String label;
  const _DayHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
