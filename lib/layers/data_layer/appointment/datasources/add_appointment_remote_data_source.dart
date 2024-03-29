import 'package:fitness_app/core/model/appointment_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/model/user_model.dart';

abstract class AddAppointmentToRemoteDataSource {
  Future<int> addAppointment(AppointmentModel appointmentModel);
}

class AddAppointmentToRemoteDataSourceImpl
    implements AddAppointmentToRemoteDataSource {
  final http.Client client;

  AddAppointmentToRemoteDataSourceImpl({required this.client});

  Future<int> _addAppointment(
      String url, AppointmentModel appointmentModel) async {
    final response = await client.post(
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

  @override
  Future<int> addAppointment(AppointmentModel appointmentModel) =>
      _addAppointment("https://wlv-c4790072fbf0.herokuapp.com/api/v1/appointments", appointmentModel);
}
