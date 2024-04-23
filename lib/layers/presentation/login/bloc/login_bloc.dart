import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/sync_data_model.dart';
import '../../../../injection_container.dart';
import '../../../../resources/strings_manager.dart';
import '../../../domain/appointment/usecases/sync.dart';
import '../../../domain/login/usecases/login.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;
  final Sync sync;
  late SyncModel syncModel;
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  final DatabaseHelper dbHelper = DatabaseHelper();

  LoginBloc({required this.login, required this.sync}) : super(LoginInitialState()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginButtonPressEvent>(loginButtonPressEvent);
  }

  FutureOr<void> loginInitialEvent(LoginInitialEvent event, Emitter<LoginState> emit) {
    emit(LoginInitialState());
  }

  FutureOr<void> loginButtonPressEvent(LoginButtonPressEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    final result = await login(event.loginModel);
    result!.fold((failure) {
      emit(LoginErrorState(message: _mapFailureToMessage(failure)));
    }, (result) {
      emit(LoggedState());
      saveUserData(result);
    });
  }

  saveUserData(UserModel user) {
    sharedPreferences.setBool('login', true);
    sharedPreferences.setInt('user_id', user.id ?? 1);
    sharedPreferences.setString('user_email', user.email);
    sharedPreferences.setString('role', user.role);
    sharedPreferences.setString('institutionEmail', user.institutionEmail);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppStrings.serverFailureMessage;
      case CacheFailure:
        return AppStrings.cacheFailureMessage;
      case LoginFailure:
        return AppStrings.loginFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
