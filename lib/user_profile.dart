import 'dart:io';
import 'package:flutter/foundation.dart';

class UserProfile extends ChangeNotifier {
  String name;
  String email;
  File? avatarImage;

  UserProfile({required this.name, required this.email, this.avatarImage});

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
}
