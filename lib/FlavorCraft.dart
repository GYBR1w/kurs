import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'RecipeScreen.dart';
import 'ProfileScreen.dart';
import 'user_profile.dart';
import 'RecipeDetailScreen.dart';
import 'FavoritesScreen.dart';
import 'RecipeSearchDelegate.dart';
import 'recipe_provider.dart';
import 'unlogin.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProfile(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context, listen: false);
    userProfile.updateName('Имя пользователя');
    userProfile.updateEmail('email@example.com');
    return MaterialApp(
      title: 'FlavorCraft',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(fontFamily: 'Montserrat'),
        ),
        colorScheme: ColorScheme.light(
          primary: Colors.orange,
          secondary: Colors.orangeAccent,
          surface: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.dark(
          primary: Colors.orange,
          secondary: Colors.orangeAccent,
          surface: Colors.grey[900]!,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const FlavorCraft(),
    );
  }
}

class FlavorCraft extends StatefulWidget {
  const FlavorCraft({super.key});

  @override
  _FlavorCraftState createState() => _FlavorCraftState();
}

class _FlavorCraftState extends State<FlavorCraft> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const RecipeScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Рецепты',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
