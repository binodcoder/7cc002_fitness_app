import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/model/appointment_model.dart';
import 'package:fitness_app/layers/domain_layer/appointment/usecases/get_appointments.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../domain_layer/register/usecases/update_user.dart';
import 'calender_event.dart';
import 'calender_state.dart';

class CalenderBloc extends Bloc<CalenderEvent, CalenderState> {
  final GetAppointments getAppointments;
  // final UpdateCalenders updateCalender;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<AppointmentModel> selectedCalenders = [];
  CalenderBloc({
    required this.getAppointments,
    //  required this.updateCalender,
  }) : super(CalenderInitialState()) {
    on<CalenderInitialEvent>(calenderInitialEvent);
    on<CalenderEditButtonClickedEvent>(calenderEditButtonClickedEvent);
    on<CalenderDeleteButtonClickedEvent>(calenderDeleteButtonClickedEvent);
    on<CalenderDeleteAllButtonClickedEvent>(calenderDeleteAllButtonClickedEvent);
    on<CalenderAddButtonClickedEvent>(calenderAddButtonClickedEvent);
    on<CalenderTileNavigateEvent>(calenderTileNavigateEvent);
  }

  FutureOr<void> calenderInitialEvent(CalenderInitialEvent event, Emitter<CalenderState> emit) async {
    emit(CalenderLoadingState());
    final appointments = await getAppointments(NoParams());

    appointments!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (appointments) {
      emit(CalenderLoadedSuccessState(appointments));
    });
  }

  FutureOr<void> calenderEditButtonClickedEvent(CalenderEditButtonClickedEvent event, Emitter<CalenderState> emit) {}

  FutureOr<void> calenderDeleteButtonClickedEvent(CalenderDeleteButtonClickedEvent event, Emitter<CalenderState> emit) async {
    // await dbHelper.deleteCalender(event.CalenderModel.id);
    // List<CalenderModel> CalenderList = await dbHelper.getCalenders();
    // emit(CalenderLoadedSuccessState(CalenderList));
  }

  FutureOr<void> calenderDeleteAllButtonClickedEvent(CalenderDeleteAllButtonClickedEvent event, Emitter<CalenderState> emit) async {
    // for (var element in selectedCalenders) {
    //   await dbHelper.deleteCalender(element.id);
    // }
    // List<CalenderModel> CalenderList = await dbHelper.getCalenders();
    // emit(CalenderLoadedSuccessState(CalenderList));
  }

  FutureOr<void> calenderAddButtonClickedEvent(CalenderAddButtonClickedEvent event, Emitter<CalenderState> emit) {
    emit(CalenderNavigateToAddCalenderActionState());
  }

  FutureOr<void> calenderTileNavigateEvent(CalenderTileNavigateEvent event, Emitter<CalenderState> emit) {
    emit(CalenderNavigateToDetailPageActionState(event.appointmentModel));
  }
}
