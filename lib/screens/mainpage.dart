import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Mainpage extends StatefulWidget {
  static const String id = 'mainpage';

  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Page')),
      body: MaterialButton(
        onPressed: () {
          DatabaseReference ref = FirebaseDatabase.instance.ref().child('test');
          ref.set('Testing Connection');
        },
        color: Colors.blue,
        minWidth: 200,
        child: Text('Test Connection'),
      ),
    );
  }
}
