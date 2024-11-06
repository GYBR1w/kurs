import 'package:flutter/material.dart';
import 'RecipeScreen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title, style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(recipe.imageUrl),
              ),
              const SizedBox(height: 16.0),
              Text(
                recipe.description,
                style: TextStyle(fontSize: 18, fontFamily: 'Montserrat'),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Ингредиенты:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
              ),
              const SizedBox(height: 8.0),
              ...recipe.ingredients.map((ingredient) => Text('• $ingredient', style: TextStyle(fontFamily: 'Montserrat'))).toList(),
              const SizedBox(height: 16.0),
              Text(
                'Инструкции:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
              ),
              const SizedBox(height: 8.0),
              Text(recipe.instructions, style: TextStyle(fontFamily: 'Montserrat')),
            ],
          ),
        ),
      ),
    );
  }
}
