import 'package:fitness_app/features/appointment/data/models/appointment_model.dart';

abstract class AppointmentDataSource {
  Future<int> addAppointment(AppointmentModel appointmentModel);
  Future<int> updateAppointment(AppointmentModel appointmentModel);
  Future<int> deleteAppointment(int appointmentId);
  Future<List<AppointmentModel>> getAppointments();
}
