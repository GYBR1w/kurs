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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userProfile = Provider.of<UserProfile>(context, listen: false);
    _nameController.text = userProfile.name;
    _emailController.text = userProfile.email;
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Редактировать профиль'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Имя'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите имя';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
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
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Сохранить'),
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

  void _showAvatarOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Посмотреть фото'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ImageViewerScreen(image: Provider.of<UserProfile>(context, listen: false).avatarImage),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Изменить фото'),
                onTap: () async {
                  ImagePicker picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    final userProfile = Provider.of<UserProfile>(context, listen: false);
                    userProfile.updateAvatar(File(pickedFile.path));
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => UnloginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Профиль',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _showAvatarOptions(context),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: userProfile.avatarImage != null
                        ? (kIsWeb ? NetworkImage(userProfile.avatarImage!.path) : FileImage(userProfile.avatarImage!))
                        : NetworkImage(''), // Замените на URL вашей картинки по умолчанию
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  userProfile.name,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 5),
                Text(
                  userProfile.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showEditDialog(context), // Кнопка для редактирования профиля
                  child: Text('Редактировать профиль'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _logout,
                  child: Text('Выйти'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageViewerScreen extends StatelessWidget {
  final File? image;

  ImageViewerScreen({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Просмотр фото'),
      ),
      body: Center(
        child: image != null
            ? (kIsWeb ? Image.network(image!.path) : Image.file(image!))
            : Text('Нет изображения'),
      ),
    );
  }
}
