import 'package:fitness_app/core/model/user_model.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/model/appointment_model.dart';
import 'package:http/http.dart' as http;

abstract class UpdateAppointmentRemoteDataSources {
  Future<int> updateAppointment(AppointmentModel appointmentModel);
}

class UpdateAppointmentRemoteDataSourcesImpl
    implements UpdateAppointmentRemoteDataSources {
  final http.Client client;

  UpdateAppointmentRemoteDataSourcesImpl({required this.client});

  Future<int> _updateAppointmentToRemote(
    String url,
  ) async {
    final response = await client.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw ServerException();
    }
    response;
  }

  @override
  Future<int> updateAppointment(AppointmentModel appointmentModel) =>
      _updateAppointmentToRemote(
          "https://wlv-c4790072fbf0.herokuapp.com/api/v1/appointments/${appointmentModel.id}");
}
