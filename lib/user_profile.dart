import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  }) : favoriteRecipes = favoriteRecipes ?? [] {
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoriteRecipesString = prefs.getString('favoriteRecipes');

    if (favoriteRecipesString != null) {
      final List<dynamic> decoded = json.decode(favoriteRecipesString);
      favoriteRecipes = decoded.map((jsonItem) => Recipe.fromJson(jsonItem)).toList();
      notifyListeners();
    }
  }


  Future<void> _saveFavoriteRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonRecipes = favoriteRecipes.map((recipe) => recipe.toJson()).toList();
    prefs.setString('favoriteRecipes', json.encode(jsonRecipes));
    notifyListeners();
  }

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
    if (!favoriteRecipes.any((item) => item.title == recipe.title)) {
      favoriteRecipes.add(recipe);
      _saveFavoriteRecipes();
      notifyListeners();
    }
  }


  void removeFavoriteRecipe(Recipe recipe) {
    favoriteRecipes.removeWhere((item) => item.title == recipe.title);
    _saveFavoriteRecipes();
    notifyListeners();
  }

  bool isFavorite(Recipe recipe) {
    return favoriteRecipes.any((item) => item.title == recipe.title);
  }

  List<Recipe> getFavoriteRecipes() {
    return favoriteRecipes;
  }
}
