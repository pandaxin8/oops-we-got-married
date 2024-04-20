// scenario.dart
class Scenario {
  final String id;
  final String description;
  final List<String> options;

  Scenario({
    required this.id,
    required this.description,
    required this.options,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) => Scenario(
        id: json['id'],
        description: json['description'],
        options: List<String>.from(json['options']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'options': options,
      };
}
