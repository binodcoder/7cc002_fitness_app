import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/features/appointment/data/models/appointment_model.dart';

class AppointmentDetailsBody extends StatelessWidget {
  final AppointmentModel appointmentModel;

  const AppointmentDetailsBody({
    super.key,
    required this.appointmentModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          SizedBox(height: AppHeight.h10),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
            tileColor: ColorManager.white,
            title: Text(
              DateFormat("yMd").format(appointmentModel.date),
              style: const TextStyle(fontSize: FontSize.s20),
            ),
            subtitle: Text(
              "${appointmentModel.startTime} to ${appointmentModel.endTime}",
              style: const TextStyle(fontSize: FontSize.s14),
            ),
          ),
          SizedBox(height: AppHeight.h20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              appointmentModel.remark ?? "",
              style: const TextStyle(fontSize: FontSize.s12),
            ),
          )
        ],
      ),
    );
  }
}
