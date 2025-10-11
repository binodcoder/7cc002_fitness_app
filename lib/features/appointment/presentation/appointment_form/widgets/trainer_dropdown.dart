import 'package:flutter/material.dart';

import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart';

class TrainerDropdown extends StatelessWidget {
  final List<TrainerEntity> trainers;
  final TrainerEntity? selectedTrainer;
  final ValueChanged<TrainerEntity?> onChanged;

  const TrainerDropdown({
    super.key,
    required this.trainers,
    required this.selectedTrainer,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TrainerEntity>(
      decoration: InputDecoration(
        fillColor: Colors.grey[10],
        filled: true,
        labelText: '  Select Trainer',
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppWidth.w4,
          vertical: AppHeight.h12,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(AppRadius.r10),
          ),
        ),
      ),
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      iconEnabledColor: ColorManager.blue,
      iconSize: 30,
      items: trainers.map((item) {
        return DropdownMenuItem<TrainerEntity>(
          value: item,
          child: Container(
            margin: const EdgeInsets.only(left: 1),
            padding: const EdgeInsets.only(left: 10),
            height: 55,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Text(
              item.name,
              style: const TextStyle(
                color: ColorManager.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      initialValue: selectedTrainer,
    );
  }
}
