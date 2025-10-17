import 'package:fitness_app/features/home/presentation/routines/bloc/routine_list_state.dart';
import 'package:flutter/material.dart';

class RoutineListErrorView extends StatelessWidget {
  const RoutineListErrorView({super.key, required this.error});

  final RoutineListErrorState error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(error.message)));
  }
}
