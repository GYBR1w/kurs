import 'dart:io';
import 'package:flutter/material.dart';
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
  }) : favoriteRecipes = favoriteRecipes ?? [];


  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    email = prefs.getString('email') ?? '';
    notifyListeners();
  }

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('email', email);
    notifyListeners();
  }

  void updateName(String newName) {
    name = newName;
    saveUserData();
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    email = newEmail;
    saveUserData();
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
