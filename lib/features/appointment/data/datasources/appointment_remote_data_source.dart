import 'package:fitness_app/features/appointment/data/datasources/appointment_data_source.dart';
import 'package:fitness_app/features/appointment/data/models/appointment_model.dart';
import 'package:http/http.dart' as http;
import 'package:fitness_app/core/errors/exceptions.dart';

// Backwards-compatible alias for tests that reference AppointmentRemoteDataSource
typedef AppointmentRemoteDataSource = AppointmentDataSource;

class AppointmentRemoteDataSourceImpl implements AppointmentDataSource {
  final http.Client client;

  AppointmentRemoteDataSourceImpl({required this.client});

  Future<List<AppointmentModel>> _getAppointments(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return appointmentModelListFromJson(response.body);
      //   return RoutineModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<int> _addAppointment(
      String url, AppointmentModel appointmentModel) async {
    final response = await client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: appointmentModelToJson(
        appointmentModel,
      ),
    );
    if (response.statusCode == 201) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  Future<int> _updateAppointmentToRemote(
      String url, AppointmentModel appointmentModel) async {
    final response = await client.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: appointmentModelToJson(
        appointmentModel,
      ),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  Future<int> _deleteAppointmentFromRemote(
    String url,
  ) async {
    final response = await client.delete(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<int> addAppointment(AppointmentModel appointmentModel) =>
      _addAppointment(
          "https://wlv-c4790072fbf0.herokuapp.com/api/v1/appointments",
          appointmentModel);

  @override
  Future<int> updateAppointment(AppointmentModel appointmentModel) =>
      _updateAppointmentToRemote(
          "https://wlv-c4790072fbf0.herokuapp.com/api/v1/appointments/${appointmentModel.id}",
          appointmentModel);

  @override
  Future<int> deleteAppointment(int appointmentId) =>
      _deleteAppointmentFromRemote(
        "https://wlv-c4790072fbf0.herokuapp.com/api/v1/appointments/$appointmentId",
      );

  @override
  Future<List<AppointmentModel>> getAppointments() => _getAppointments(
      "https://wlv-c4790072fbf0.herokuapp.com/api/v1/appointments");
}
