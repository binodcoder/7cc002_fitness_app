import 'package:fitness_app/core/fakes/fake_repositories.dart';
import 'package:fitness_app/features/appointment/data/datasources/appointment_data_source.dart';
import 'package:fitness_app/features/appointment/data/datasources/appointment_remote_data_source.dart';
import 'package:fitness_app/features/appointment/data/datasources/firebase_appointment_remote_data_source.dart';
import 'package:fitness_app/features/appointment/data/repositories/appointment_repositories_impl.dart';
import 'package:fitness_app/features/appointment/domain/repositories/appointment_repositories.dart';
import 'package:fitness_app/features/appointment/domain/usecases/add_appointment.dart';
import 'package:fitness_app/features/appointment/domain/usecases/delete_appointment.dart';
import 'package:fitness_app/features/appointment/domain/usecases/get_appointments.dart';
import 'package:fitness_app/features/appointment/domain/usecases/update_appointment.dart';
import 'package:fitness_app/features/appointment/presentation/appointment_form/bloc/appointment_form_bloc.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/calendar_bloc.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/event_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:fitness_app/core/services/availability_service.dart';

void registerAppointmentInfrastructureDependencies(
    GetIt sl, bool kUseFakeData, bool kUseFirebaseData) {
  //appointment
  sl.registerFactory(() => AppointmentFormBloc(
      addAppointment: sl(), updateAppointment: sl(), sync: sl()));
  sl.registerFactory(() => CalendarBloc(
      getAppointments: sl(), deleteAppointment: sl(), updateAppointment: sl()));
  sl.registerFactory(
      () => EventBloc(getAppointments: sl(), deleteAppointment: sl()));

  sl.registerLazySingleton(() => AddAppointment(sl()));
  sl.registerLazySingleton(() => UpdateAppointment(sl()));
  sl.registerLazySingleton(() => GetAppointments(sl()));
  sl.registerLazySingleton(() => DeleteAppointment(sl()));
  sl.registerLazySingleton<AppointmentRepositories>(() => kUseFakeData
      ? FakeAppointmentRepositories()
      : AppointmentRepositoriesImpl(appointmentRemoteDataSource: sl()));

  sl.registerLazySingleton<AppointmentDataSource>(() => kUseFirebaseData
      ? FirebaseAppointmentRemoteDataSource()
      : AppointmentRemoteDataSourceImpl(client: sl()));

  // Availability service for trainer slots
  sl.registerLazySingleton<AppointmentAvailabilityService>(
      () => AppointmentAvailabilityService());
}
