import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_firebase.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  String? _customID;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchCustomID();
  }

  Future<void> _fetchCustomID() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          _customID = userDoc['customID'];
        });
      } catch (e) {
        print('Error fetching custom ID: $e');
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthWithCustomID()),
      );
      print('Вы успешно вышли из аккаунта.');
    } catch (e) {
      print('Ошибка при выходе: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => signOut(context),
          icon: Icon(Icons.door_back_door),
        ),
      ),
      body: Center(
        child: _customID == null
            ? CircularProgressIndicator() // Show loading indicator while fetching custom ID
            : Text('Your Custom ID: $_customID', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
