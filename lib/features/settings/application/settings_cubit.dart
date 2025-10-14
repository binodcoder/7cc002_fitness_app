import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._prefs) : super(const SettingsState());

  final SharedPreferences _prefs;

  static const _kDistance = 'settings_distance_unit';
  static const _kWeight = 'settings_weight_unit';
  static const _kTime24h = 'settings_time_24h';
  static const _kPush = 'settings_push_enabled';

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final distance = _prefs.getString(_kDistance) ?? state.distanceUnit;
    final weight = _prefs.getString(_kWeight) ?? state.weightUnit;
    final time24h = _prefs.getBool(_kTime24h) ?? state.time24h;
    final push = _prefs.getBool(_kPush) ?? state.pushEnabled;
    emit(SettingsState(
      distanceUnit: distance,
      weightUnit: weight,
      time24h: time24h,
      pushEnabled: push,
      loading: false,
    ));
  }

  void setDistanceUnit(String value) {
    _prefs.setString(_kDistance, value);
    emit(state.copyWith(distanceUnit: value));
  }

  void setWeightUnit(String value) {
    _prefs.setString(_kWeight, value);
    emit(state.copyWith(weightUnit: value));
  }

  void setTime24h(bool value) {
    _prefs.setBool(_kTime24h, value);
    emit(state.copyWith(time24h: value));
  }

  void setPushEnabled(bool value) {
    _prefs.setBool(_kPush, value);
    emit(state.copyWith(pushEnabled: value));
  }
}
