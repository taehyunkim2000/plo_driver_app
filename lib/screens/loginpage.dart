import 'package:flutter/material.dart';
import 'package:plo_driver_app/screens/registration.dart';

class Loginpage extends StatefulWidget {
  static const String id = 'login';

  const Loginpage({super.key});

  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RegistrationPage.id,
              (route) => false,
            );
          },
          child: Text('Go to Registration'),
        ),
      ),
    );
  }
}
