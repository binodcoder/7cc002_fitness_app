import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String distanceUnit; // 'km' or 'mi'
  final String weightUnit; // 'kg' or 'lb'
  final bool time24h; // true -> 24h
  final bool pushEnabled;
  final bool loading;

  const SettingsState({
    this.distanceUnit = 'km',
    this.weightUnit = 'kg',
    this.time24h = true,
    this.pushEnabled = true,
    this.loading = false,
  });

  SettingsState copyWith({
    String? distanceUnit,
    String? weightUnit,
    bool? time24h,
    bool? pushEnabled,
    bool? loading,
  }) {
    return SettingsState(
      distanceUnit: distanceUnit ?? this.distanceUnit,
      weightUnit: weightUnit ?? this.weightUnit,
      time24h: time24h ?? this.time24h,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props =>
      [distanceUnit, weightUnit, time24h, pushEnabled, loading];
}
