import 'package:equatable/equatable.dart';

class LiveTraining extends Equatable {
  final int trainerId;
  final String title;
  final String description;
  final DateTime trainingDate;
  final String startTime;
  final String endTime;
  final String? streamUrl;

  const LiveTraining({
    required this.trainerId,
    required this.title,
    required this.description,
    required this.trainingDate,
    required this.startTime,
    required this.endTime,
    this.streamUrl,
  });

  @override
  List<Object?> get props => [
        trainerId,
        title,
        description,
        trainingDate,
        startTime,
        endTime,
        streamUrl
      ];
}
