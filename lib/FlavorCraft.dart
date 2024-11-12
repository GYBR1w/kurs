import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'RecipeScreen.dart';
import 'Profile.dart';
import 'user_profile.dart';
import 'RecipeDetailScreen.dart';

class FlavorCraft extends StatefulWidget {
  @override
  _FlavorCraftState createState() => _FlavorCraftState();
}

class _FlavorCraftState extends State<FlavorCraft> {
  int _selectedIndex = 0;


  static List<Widget> _widgetOptions = <Widget>[
    RecipeScreen(),
    Center(child: Text('Контент для Поиска', style: TextStyle(fontSize: 24))),
    Center(child: Text('Контент для Избранного', style: TextStyle(fontSize: 24))),
    ProfileScreen(),
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
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? 'Рецепты'
              : _selectedIndex == 2
              ? 'Избранное'
              : _selectedIndex == 3
              ? 'Профиль'
              : '',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _selectedIndex == 2
          ? ListView.builder(
        itemCount: favoriteRecipes.length,
        itemBuilder: (context, index) {
          final recipe = favoriteRecipes[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(recipe.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(recipe.title),
              subtitle: Text(recipe.description),
              trailing: Icon(Icons.favorite, color: Colors.red),
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
      )
          : _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(color: Colors.blue),
        unselectedLabelStyle: TextStyle(color: Colors.blue),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.home),
            label: 'Рецепты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Поиск',
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
