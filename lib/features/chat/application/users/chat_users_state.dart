import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';

class ChatUsersState extends Equatable {
  final bool loading;
  final List<User> users;
  final String? errorMessage;
  const ChatUsersState(
      {this.loading = false, this.users = const [], this.errorMessage});

  ChatUsersState copyWith(
      {bool? loading,
      List<User>? users,
      String? errorMessage,
      bool clearError = false}) {
    return ChatUsersState(
      loading: loading ?? this.loading,
      users: users ?? this.users,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [loading, users, errorMessage];
}
