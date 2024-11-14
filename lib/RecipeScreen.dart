import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'RecipeDetailScreen.dart';
import 'user_profile.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Recipe {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;

  Recipe({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: json['instructions'],
    );
  }
}

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? recipesString = prefs.getString('recipes');

    if (recipesString != null) {
      final List<dynamic> decoded = json.decode(recipesString);
      setState(() {
        recipes = decoded.map((jsonItem) => Recipe.fromJson(jsonItem)).toList();
      });
    } else {
      setState(() {
        recipes = [
          Recipe(
            title: 'Спагетти Карбонара',
            description: 'Классическое итальянское блюдо...',
            imageUrl: 'https://eda.ru/images/RecipeOpenGraph/1200x630/pasta-karbonara-pasta-alla-carbonara_50865_ogimage.jpg',
            ingredients: ['Спагетти (400 г)', 'Панчетта (150 г)', 'Яйцо (2 шт.)', 'Пармезан (50 г)', 'Чёрный перец (по вкусу)', 'Соль (по вкусу)'],
            instructions: '1. Отварите спагетти 2. Добавьте соус 3. Смешайте.',
          ),
          Recipe(
            title: 'Борщ',
            description: 'Традиционный суп',
            imageUrl: 'https://eda.ru/images/RecipePhoto/930x622/borsch-s-hrenom_29213_photo_56956.webp',
            ingredients: ['Свекла (1 шт.)', 'Картофель (3 шт.)', 'Морковь (1 шт.)', 'Лук (1 шт.)', 'Капуста (200 г)'],
            instructions: '1. Нарезать все ингредиенты 2. Закинуть в кастрюлю. 3. Готово!',
          ),
        ];
        _saveRecipes();
      });
    }
  }

  Future<void> _saveRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonRecipes = recipes.map((recipe) => recipe.toJson()).toList();
    prefs.setString('recipes', json.encode(jsonRecipes));
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          final isFavorite = userProfile.isFavorite(recipe);

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(
                recipe.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 50,
                ),
              ),
              title: Text(recipe.title),
              subtitle: Text(recipe.description),
              trailing: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  if (isFavorite) {
                    userProfile.removeFavoriteRecipe(recipe);
                  } else {
                    userProfile.addFavoriteRecipe(recipe);
                  }
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: recipe),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 145, 255, 100),
        onPressed: _showAddRecipeDialog,
        child: Icon(Icons.add),
        tooltip: 'Добавить рецепт',
      ),
    );
  }

  Future<void> _showAddRecipeDialog() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    final TextEditingController ingredientsController = TextEditingController();
    final TextEditingController instructionsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить новый рецепт'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: 'Название')),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Описание')),
              TextField(controller: imageUrlController, decoration: InputDecoration(labelText: 'URL изображения')),
              TextField(controller: ingredientsController, decoration: InputDecoration(labelText: 'Ингредиенты (через запятую)')),
              TextField(controller: instructionsController, decoration: InputDecoration(labelText: 'Инструкции')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final ingredients = ingredientsController.text.split(',').map((s) => s.trim()).toList();
                setState(() {
                  recipes.add(Recipe(
                    title: titleController.text,
                    description: descriptionController.text,
                    imageUrl: imageUrlController.text,
                    ingredients: ingredients,
                    instructions: instructionsController.text,
                  ));
                  _saveRecipes();
                });
                Navigator.of(context).pop();
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }
}
