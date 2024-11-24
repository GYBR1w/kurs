import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/recipe.dart';
import 'user_profile.dart';
import 'widgets/recipe_card.dart';
import 'RecipeDetailScreen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Избранные рецепты',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Expanded(
              child: Consumer<UserProfile>(
                builder: (context, userProfile, child) {
                  final favoriteRecipes = userProfile.favoriteRecipes;

                  if (favoriteRecipes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'У вас пока нет избранных рецептов',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: favoriteRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = favoriteRecipes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: RecipeCard(
                          recipe: recipe,
                          isFavorite: true,
                          onFavoriteChanged: (isFavorite) {
                            if (!isFavorite) {
                              userProfile.removeFavoriteRecipe(recipe);
                            }
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailScreen(recipe: recipe),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
