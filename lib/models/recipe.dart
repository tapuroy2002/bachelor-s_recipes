class Recipe {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> instructions;
  final int duration;
  final String difficulty;

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.duration,
    required this.difficulty,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      duration: json['duration'],
      difficulty: json['difficulty'],
    );
  }
}
