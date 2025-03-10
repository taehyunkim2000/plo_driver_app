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
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: MaterialButton(
        onPressed: (){

        },
        color: Colors.blue,
        minWidth: 200,
        child: Text('Hello'),
      ),
    );
  }
}