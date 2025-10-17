import 'dart:async';
import 'package:fitness_app/features/admin/domain/usecases/get_users.dart';
import 'package:fitness_app/features/admin/domain/usecases/update_user.dart';
import 'package:fitness_app/features/admin/presentation/cubit/admin_state.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminCubit extends Cubit<AdminState> {
  final GetUsers getUsers;
  final UpdateUser updateUser;
  StreamSubscription<List<User>>? _subscription;
  AdminCubit({required this.getUsers, required this.updateUser})
      : super(AdminLoadingState());

  void startListening() {
    emit(AdminLoadingState());
    _subscription?.cancel();
    _subscription = getUsers().listen((users) {
      emit(AdminLoadedState(users));
    }, onError: (error) {
      emit(AdminErrorState(error.toString()));
    });
  }

  void updateRole(int userId, String role) {
    updateUser(userId, role);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
