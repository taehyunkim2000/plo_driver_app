import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:plo_driver_app/brand_colors.dart';
import 'package:plo_driver_app/screens/mainpage.dart';
import 'package:plo_driver_app/screens/registration.dart';
import 'package:plo_driver_app/widgets/ProgressDialog.dart';
import 'package:plo_driver_app/widgets/taxi_button.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  static const String id = 'login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackBar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void login() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (BuildContext context) => ProgressDialog(status: 'Logging you in'),
    );

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child(
          'drivers/${user.uid}',
        );
        DatabaseEvent event = await userRef.once();

        if (event.snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Mainpage.id,
            (route) => false,
          );
        }
      }
    } catch (ex) {
      Navigator.pop(context);
      if (ex is FirebaseAuthException) {
        showSnackBar(ex.message ?? "Authentication failed");
      } else {
        showSnackBar("An error occurred");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(0.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 100.0),
                    Image(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: 100.0,
                      image: AssetImage('images/logo.png'),
                    ),
                    SizedBox(height: 40),

                    Text(
                      'Sign In as a Rider',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                    ),

                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email address',
                              labelStyle: TextStyle(fontSize: 14.0),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0,
                              ),
                            ),
                            style: TextStyle(fontSize: 14.0),
                          ), //Textfield
                          SizedBox(height: 10.0),

                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(fontSize: 14.0),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0,
                              ),
                            ),
                            style: TextStyle(fontSize: 14.0),
                          ), //Textfield

                          SizedBox(height: 40.0),

                          TaxiButton(
                            title: 'Login',
                            color: BrandColors.colorAccentPurple,
                            onPressed: () async {
                              // 인터넷 연결 확인은 유지하되, 더 유연하게 처리
                              try {
                                var connectivityResult =
                                    await Connectivity().checkConnectivity();
                                if (connectivityResult !=
                                        ConnectivityResult.mobile &&
                                    connectivityResult !=
                                        ConnectivityResult.wifi) {
                                  // 인터넷 연결이 없을 때 사용자에게 선택권 제공
                                  showDialog(
                                    context: context,
                                    builder:
                                        (BuildContext context) => AlertDialog(
                                          title: Text('인터넷 연결 확인'),
                                          content: Text(
                                            '인터넷 연결이 불안정합니다. 계속 진행하시겠습니까?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('취소'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                // 사용자가 확인을 누르면 로그인 진행
                                                if (!emailController.text
                                                    .contains('@')) {
                                                  showSnackBar(
                                                    'Please enter a valid email address',
                                                  );
                                                  return;
                                                }

                                                if (passwordController
                                                        .text
                                                        .length <
                                                    8) {
                                                  showSnackBar(
                                                    'Password must be at least 8 characters long',
                                                  );
                                                  return;
                                                }

                                                login();
                                              },
                                              child: Text('계속'),
                                            ),
                                          ],
                                        ),
                                  );
                                } else {
                                  // 인터넷 연결이 정상일 때
                                  if (!emailController.text.contains('@')) {
                                    showSnackBar(
                                      'Please enter a valid email address',
                                    );
                                    return;
                                  }

                                  if (passwordController.text.length < 8) {
                                    showSnackBar(
                                      'Password must be at least 8 characters long',
                                    );
                                    return;
                                  }

                                  login();
                                }
                              } catch (e) {
                                // 연결 확인 중 오류 발생 시 로그인 시도
                                login();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RegistrationPage.id,
                    (route) => false,
                  );
                },
                child: Text('Sign up as a driver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
