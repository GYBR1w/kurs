import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'RecipeScreen.dart';
import 'user_profile.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);
    final isFavorite = userProfile.isFavorite(recipe);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(recipe.title, style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  recipe.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 150,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                recipe.description,
                style: const TextStyle(fontSize: 18, fontFamily: 'Montserrat'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Ингредиенты:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
              ),
              const SizedBox(height: 8.0),
              ...recipe.ingredients.map((ingredient) => Text('• $ingredient', style: const TextStyle(fontFamily: 'Montserrat'))),
              const SizedBox(height: 16.0),
              const Text(
                'Инструкции:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
              ),
              const SizedBox(height: 8.0),
              Text(recipe.instructions, style: const TextStyle(fontFamily: 'Montserrat')),
            ],
          ),
        ),
      ),
    );
  }
}
