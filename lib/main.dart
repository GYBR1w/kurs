import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_profile.dart';
import 'FlavorCraft.dart';
import 'Profile.dart';
import 'RecipeScreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProfile(name: '', email: '', avatarImage: null),
      child: MaterialApp(
        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FlavorCraft(),
      ),
    );
  }
}
