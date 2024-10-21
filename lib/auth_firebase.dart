import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWithCustomID extends StatefulWidget {
  @override
  _AuthWithCustomIDState createState() => _AuthWithCustomIDState();
}

class _AuthWithCustomIDState extends State<AuthWithCustomID> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _idController = TextEditingController();
  User? _user;

  // Функция для входа пользователя с уникальным номером
  Future<void> _loginWithCustomID() async {
    String customID = _idController.text;

    if (customID.isNotEmpty) {
      try {
        // Анонимная авторизация
        UserCredential userCredential = await _auth.signInAnonymously();
        _user = userCredential.user;

        // Здесь вы можете привязать уникальный номер к пользователю
        if (_user != null) {
          // Например, сохраняем customID в Firestore или Realtime Database
          print('User signed in with ID: $customID');
          print('Firebase User ID: ${_user?.uid}');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Please enter a valid ID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom ID Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'Enter your unique ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginWithCustomID,
              child: Text('Login with Custom ID'),
            ),
          ],
        ),
      ),
    );
  }
}
