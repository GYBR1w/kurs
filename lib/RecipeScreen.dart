import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'RecipeDetailScreen.dart';
import 'user_profile.dart';

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
}

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final List<Recipe> recipes = [
    Recipe(
      title: 'Спагетти Карбонара',
      description: 'Классическое итальянское блюдо...',
      imageUrl: 'https://eda.ru/images/RecipeOpenGraph/1200x630/pasta-karbonara-pasta-alla-carbonara_50865_ogimage.jpg',
      ingredients: ['Спагетти (400 г)', 'Панчетта (150 г)', 'Яйцо (2 шт.)', 'Пармезан (50 г)', 'Чёрный перец (по вкусу)', 'Соль (по вкусу)'],
      instructions: '1. Отварите спагетти...',
    ),
    // Другие рецепты...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Рецепты',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          final userProfile = Provider.of<UserProfile>(context);
          final isFavorite = userProfile.isFavorite(recipe);

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(recipe.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
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
