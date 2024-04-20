import 'package:fitness_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/model/appointment_model.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/font_manager.dart';
import '../../../../../resources/values_manager.dart';

class AppointmentDetailsPage extends StatefulWidget {
  const AppointmentDetailsPage({
    Key? key,
    this.appointmentModel,
  }) : super(key: key);

  final AppointmentModel? appointmentModel;

  @override
  State<AppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: const Text(
          AppStrings.titleAppointmentLabel,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            SizedBox(
              height: AppHeight.h10,
            ),
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
              tileColor: ColorManager.white,
              title: Text(
                DateFormat("yMd").format(widget.appointmentModel!.date),
                style: const TextStyle(
                  fontSize: FontSize.s20,
                ),
              ),
              subtitle: Text(
                "${widget.appointmentModel!.startTime} to ${widget.appointmentModel!.endTime}",
                style: const TextStyle(fontSize: FontSize.s14),
              ),
            ),
            SizedBox(
              height: AppHeight.h20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.appointmentModel?.remark ?? "",
                style: const TextStyle(fontSize: FontSize.s12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
