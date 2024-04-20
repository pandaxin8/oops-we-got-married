// player.dart
class Player {
  final String id;
  final String name;
  final List<String> interests;
  final String mood;

  Player({
    required this.id,
    required this.name,
    required this.interests,
    required this.mood,
  });

  // Add fromJson and toJson methods similar to Scenario if you need to serialize/deserialize.
}
