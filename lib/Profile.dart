import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'user_profile.dart';
import 'unlogin.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Имя пользователя',);
  final _emailController = TextEditingController(text: 'email@example.com');
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile = Provider.of<UserProfile>(context, listen: false);
      if (userProfile.name.isNotEmpty) _nameController.text = userProfile.name;
      if (userProfile.email.isNotEmpty) _emailController.text = userProfile.email;
    });
  }

  Future<void> _showEditDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактировать профиль'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Имя'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите имя';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите email';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _nameController.text = Provider.of<UserProfile>(context, listen: false).name.isNotEmpty ? Provider.of<UserProfile>(context, listen: false).name : 'Имя пользователя';
                  _emailController.text = Provider.of<UserProfile>(context, listen: false).email.isNotEmpty ? Provider.of<UserProfile>(context, listen: false).email : 'email@example.com';
                });
              },
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final userProfile = Provider.of<UserProfile>(context, listen: false);
                  userProfile.updateName(_nameController.text);
                  userProfile.updateEmail(_emailController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final userProfile = Provider.of<UserProfile>(context, listen: false);
      userProfile.updateAvatar(File(image.path));
    }
  }

  void _logout() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UnloginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Профиль',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: userProfile.avatarImage != null
                        ? (kIsWeb ? NetworkImage(userProfile.avatarImage!.path) : FileImage(userProfile.avatarImage!))
                        : null,
                    child: userProfile.avatarImage == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(userProfile.name.isNotEmpty ? userProfile.name : 'Имя пользователя', style: const TextStyle(fontSize: 24, fontFamily: 'Montserrat',)),
                const SizedBox(height: 5),
                Text(userProfile.email.isNotEmpty ? userProfile.email : 'email@example.com', style: const TextStyle(fontSize: 16, fontFamily: 'Montserrat', color: Colors.grey)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showEditDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Редактировать профиль',
                    style: TextStyle(fontSize: 18, fontFamily: 'Montserrat', color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: _logout,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(double.infinity, 50), //
                  ),
                  child: const Text(
                    'Выйти',
                    style: TextStyle(fontSize: 18, fontFamily: 'Montserrat', color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
