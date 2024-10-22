import 'dart:developer';

import 'package:aiu_project/new.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthWithCustomID extends StatefulWidget {
  @override
  _AuthWithCustomIDState createState() => _AuthWithCustomIDState();
}

class _AuthWithCustomIDState extends State<AuthWithCustomID> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  User? _user;

  // Функция для входа пользователя с уникальным номером
  Future<void> _loginWithCustomID() async {
    String customID = _idController.text;
    String password = _passwordController.text;

    if (customID.isNotEmpty) {
      try {
        // Анонимная авторизация
        UserCredential userCredential = await _auth.signInAnonymously();
        _user = userCredential.user;

        // Сохраняем customID в Firestore
        if (_user != null) {
          await _saveUserID(_user!.uid, customID, password);
          log('User signed in with ID: $customID');
          log('Firebase User ID: ${_user?.uid}');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const NewScreen(),
            ),
          );

        }
      } catch (e) {
        log('Error: $e');
      }
    } else {
      log('Please enter a valid ID');
    }
  }

  // Сохранение ID пользователя в Firestore
  Future<void> _saveUserID(String uid, String customID, String password) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'customID': customID,
      'password': password,
    });
    log('Custom ID saved in Firestore');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom ID Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 250.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _idController,
                decoration:
                const InputDecoration(
                  icon: Icon(Icons.perm_identity),
                    iconColor: Colors.blueAccent,
                    labelText: 'Enter your unique ID'),
              ),
              TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  iconColor: Colors.blueAccent,
                  icon: Icon(Icons.password),

                    labelText: 'Enter your password'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loginWithCustomID,
                  child: Text('Login with Custom ID'),
                ),
              ),
            ],
          ),
      ),
    );
  }
}
