import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Profile.dart';
import 'RecipeScreen.dart';
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
    List<Recipe> favoriteRecipes = userProfile.favoriteRecipes;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _selectedIndex == 2  // Вкладка Избранное
          ? ListView.builder(
        itemCount: favoriteRecipes.length,
        itemBuilder: (context, index) {
          final recipe = favoriteRecipes[index];
          return ListTile(
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
          );
        },
      )
          : _widgetOptions.elementAt(_selectedIndex),  // Выводим другие вкладки

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black,),
            label: 'Рецепты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black,),
            label: 'Поиск',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.black,),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.black,),
            label: 'Профиль',
          ),
        ],
        selectedItemColor: Colors.blueAccent,
        selectedLabelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
      ),
    );
  }
}
