import 'package:flutter/material.dart';

class Recipe {
  final String title;
  final String description;
  final String imageUrl;

  Recipe({required this.title, required this.description, required this.imageUrl});
}

class RecipeScreen extends StatelessWidget {
  // Пример списка рецептов
  final List<Recipe> recipes = [
    Recipe(
      title: 'Рецепт 1',
      description: 'Описание рецепта 1',
      imageUrl: 'https://via.placeholder.com/150', // Замените на реальные URL изображений
    ),
    Recipe(
      title: 'Рецепт 2',
      description: 'Описание рецепта 2',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Recipe(
      title: 'Рецепт 3',
      description: 'Описание рецепта 3',
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Белый фон экрана рецептов
      appBar: AppBar(
        title: const Text('Рецепты'),
        backgroundColor: Colors.white, // Белый фон для AppBar
        iconTheme: IconThemeData(color: Colors.black), // Черные иконки в AppBar
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(recipe.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(recipe.title),
              subtitle: Text(recipe.description),
              onTap: () {
                // Здесь можно реализовать переход на экран деталей рецепта
              },
            ),
          );
        },
      ),
    );
  }
}
