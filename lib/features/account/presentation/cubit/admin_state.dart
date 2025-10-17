import 'package:equatable/equatable.dart';
import 'package:fitness_app/core/entities/user.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminLoadingState extends AdminState {}

class AdminLoadedState extends AdminState {
  const AdminLoadedState(this.users);
  final List<User> users;

  @override
  List<Object?> get props => [users];
}

class AdminErrorState extends AdminState {
  const AdminErrorState(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
