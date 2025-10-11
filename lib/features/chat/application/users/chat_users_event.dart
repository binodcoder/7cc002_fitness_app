import 'package:equatable/equatable.dart';

abstract class ChatUsersEvent extends Equatable {
  const ChatUsersEvent();
  @override
  List<Object?> get props => const [];
}

class ChatUsersRequested extends ChatUsersEvent {
  const ChatUsersRequested();
}
