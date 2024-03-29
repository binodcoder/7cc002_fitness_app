import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/model/user_model.dart';
import 'package:fitness_app/global.dart';
import 'package:fitness_app/layers/presentation_layer/register/bloc/user_add_event.dart';
import 'package:fitness_app/layers/presentation_layer/register/bloc/user_add_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/model/sync_data_model.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../injection_container.dart';
import '../../../domain_layer/login/usecases/login.dart';
import '../../../domain_layer/appointment/usecases/sync.dart';
import '../../../domain_layer/register/usecases/add_user.dart';
import '../../../domain_layer/register/usecases/update_user.dart';
import '../../../domain_layer/routine/usecases/get_routines.dart';
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
    final result = await login(event.loginModel);

    result!.fold((failure) {
      emit(LoginErrorState());
    }, (result) {
      emit(LoggedState());
      saveUserData(result);
    });
  }

  saveUserData(UserModel user) {
    sharedPreferences.setBool('login', true);
    sharedPreferences.setInt('user_id', user.id ?? 1);
    sharedPreferences.setString('user_email', user.email);
  }
}
