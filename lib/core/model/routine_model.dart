import '../entities/routine.dart';

class RoutineModel extends Routine {
  RoutineModel(
    String id,
    String title,
    String content,
    String imagePath,
    int isSelected,
  ) : super(
          id,
          title,
          content,
          imagePath,
          isSelected,
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'isSelected': isSelected,
    };
  }
}
