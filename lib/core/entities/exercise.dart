class Exercise {
  final String id;
  String name;
  String description;
  String targetMuscleGroups;
  String difficulty;
  List<String> equipment;
  String imageUrl;
  String videoUrl;

  Exercise(
    this.id,
    this.name,
    this.description,
    this.targetMuscleGroups,
    this.difficulty,
    this.equipment,
    this.imageUrl,
    this.videoUrl,
  );
}
