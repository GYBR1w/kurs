import 'dart:io';
import 'package:flutter/foundation.dart';
import 'RecipeScreen.dart';

class UserProfile extends ChangeNotifier {
  String name;
  String email;
  File? avatarImage;
  List<Recipe> favoriteRecipes;

  UserProfile({
    required this.name,
    required this.email,
    this.avatarImage,
    List<Recipe>? favoriteRecipes,
  }) : favoriteRecipes = favoriteRecipes ?? [];

  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }

  void updateAvatar(File? newAvatar) {
    avatarImage = newAvatar;
    notifyListeners();
  }


  void addFavoriteRecipe(Recipe recipe) {
    if (!favoriteRecipes.contains(recipe)) {
      favoriteRecipes.add(recipe);
      notifyListeners();
    }
  }


  void removeFavoriteRecipe(Recipe recipe) {
    favoriteRecipes.remove(recipe);
    notifyListeners();
  }


  bool isFavorite(Recipe recipe) {
    return favoriteRecipes.contains(recipe);
  }


  List<Recipe> getFavoriteRecipes() {
    return favoriteRecipes;
  }
}
