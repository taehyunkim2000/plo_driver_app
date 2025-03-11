import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/mainpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
        Platform.isIOS
            ? const FirebaseOptions(
              apiKey: 'AIzaSyBbAeoUHY5ptkBe-xR54A45fVnJX7iS3YA',
              appId: '1:425631894947:ios:e9b63aa2e048a45095de16',
              messagingSenderId: '425631894947',
              projectId: 'geetaxi-aa379',
              databaseURL: 'https://geetaxi-aa379-default-rtdb.firebaseio.com',
            )
            : const FirebaseOptions(
              apiKey: 'AIzaSyAknGQdA7yAS5SICTW8lOKilEN7FBpNS-U',
              appId: '1:425631894947:android:783ac2ba27d2db6e95de16',
              messagingSenderId: '425631894947',
              projectId: 'geetaxi-aa379',
              databaseURL: 'https://geetaxi-aa379-default-rtdb.firebaseio.com',
            ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Mainpage.id,
      routes: {Mainpage.id: (context) => Mainpage()},
    );
  }
}
