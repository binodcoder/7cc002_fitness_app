import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/features/register/domain/entities/user.dart' as user_entity;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/core/db/db_helper.dart';
import 'package:fitness_app/core/mappers/map_failure_to_message.dart';
import 'package:fitness_app/features/appointment/data/models/sync_data_model.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/features/appointment/domain/usecases/sync.dart';
import '../../domain/usecases/login.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;
  final Sync sync;
  late SyncModel syncModel;
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  final DatabaseHelper dbHelper = DatabaseHelper();

  LoginBloc({required this.login, required this.sync})
      : super(LoginInitialState()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginButtonPressEvent>(loginButtonPressEvent);
  }

  FutureOr<void> loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) {
    emit(LoginInitialState());
  }

  FutureOr<void> loginButtonPressEvent(
      LoginButtonPressEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    final result = await login(event.login);
    result!.fold((failure) {
      emit(LoginErrorState(message: mapFailureToMessage(failure)));
    }, (result) {
      emit(LoggedState());
      saveUserData(result);
    });
  }

  saveUserData(user_entity.User user) {
    sharedPreferences.setBool('login', true);
    sharedPreferences.setInt('user_id', user.id ?? 1);
    sharedPreferences.setString('user_email', user.email);
    sharedPreferences.setString('role', user.role);
    sharedPreferences.setString('institutionEmail', user.institutionEmail);
  }
}
