import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'RecipeScreen.dart';
import 'Profile.dart';
import 'user_profile.dart';
import 'RecipeDetailScreen.dart';

class FlavorCraft extends StatefulWidget {
  const FlavorCraft({super.key});

  @override
  _FlavorCraftState createState() => _FlavorCraftState();
}

class _FlavorCraftState extends State<FlavorCraft> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const RecipeScreen(),
    const Center(
        child: Text('Избранное',
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 24))),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);
    List<Recipe> favoriteRecipes = userProfile.getFavoriteRecipes();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _selectedIndex != 0
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                _selectedIndex == 1
                    ? 'Избранное'
                    : _selectedIndex == 2
                        ? 'Профиль'
                        : '',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            )
          : null,
      body: _selectedIndex == 1
          ? ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      recipe.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                    title: Text(recipe.title,
                        style: const TextStyle(fontFamily: 'Montserrat')),
                    subtitle: Text(recipe.description,
                        style: const TextStyle(fontFamily: 'Montserrat')),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        userProfile.removeFavoriteRecipe(recipe);
                      },
                    ),
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
            )
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        selectedLabelStyle:
            const TextStyle(fontFamily: 'Montserrat', color: Colors.blue),
        unselectedLabelStyle:
            const TextStyle(fontFamily: 'Montserrat', color: Colors.blue),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.home),
            label: 'Рецепты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
