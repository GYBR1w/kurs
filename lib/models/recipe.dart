import 'package:flutter/foundation.dart';

class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final String category;
  final int cookingTime;
  final String difficulty;
  final double rating;
  final List<String> comments;
  final DateTime dateAdded;

  Recipe({
    String? id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    this.category = 'Общее',
    int? cookingTime,
    this.difficulty = 'Средний',
    this.rating = 0.0,
    List<String>? comments,
    DateTime? dateAdded,
  })  : this.id = id ?? '${DateTime.now().millisecondsSinceEpoch}_${title.hashCode}',
        this.cookingTime = cookingTime ?? 0,
        this.comments = comments ?? [],
        this.dateAdded = dateAdded ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'instructions': instructions,
      'category': category,
      'cookingTime': cookingTime,
      'difficulty': difficulty,
      'rating': rating,
      'comments': comments,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: json['instructions'],
      category: json['category'] ?? 'Общее',
      cookingTime: json['cookingTime'] ?? 0,
      difficulty: json['difficulty'] ?? 'Средний',
      rating: json['rating']?.toDouble() ?? 0.0,
      comments: List<String>.from(json['comments'] ?? []),
      dateAdded: DateTime.parse(json['dateAdded']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recipe && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
