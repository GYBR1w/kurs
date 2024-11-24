import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FlavorCraft.dart';
import 'user_profile.dart';
import 'recipe_provider.dart';
import 'unlogin.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProfile()),
        ChangeNotifierProvider(create: (context) => RecipeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlavorCraft',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
      ),
      home: const UnloginScreen(),
    );
  }
}
