import 'package:plo_driver_app/brand_colors.dart';
import 'package:plo_driver_app/screens/loginpage.dart';
import 'package:plo_driver_app/screens/mainpage.dart';
import 'package:plo_driver_app/screens/vehicleinfo.dart';
import 'package:plo_driver_app/widgets/ProgressDialog.dart';
import 'package:plo_driver_app/widgets/taxi_button.dart';
import 'package:plo_driver_app/widgets/globalvariables.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'register';

  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

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

  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  void registerUser(BuildContext context) async {
    showDialog(
      context: context,
      builder:
          (BuildContext context) =>
              ProgressDialog(status: 'Registering you...'),
    );

    final User? user =
        (await _auth
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            )
            .catchError((ex) {
              Navigator.pop(context);
              PlatformException thisEx = ex;
              showSnackBar(thisEx.message ?? 'An error occurred');
            })).user;

    Navigator.pop(context);
    if (user != null) {
      DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child(
        'drivers/${user.uid}',
      );

      Map userMap = {
        'fullname': fullnameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      };

      newUserRef.set(userMap);

      currentFirebaseUser = user;

      Navigator.pushNamed(context, VehicleInfoPage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 70),
                Image(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('images/logo.png'),
                ),

                SizedBox(height: 40),

                Text(
                  'Create a DRIVER\'s Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'brand-bold'),
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      // Fullname
                      TextField(
                        controller: fullnameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Full name',
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10),

                      // Email Address
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10),

                      // Phone
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone number',
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10),

                      // Password
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 40),

                      TaxiButton(
                        title: 'REGISTER',
                        color: BrandColors.colorAccentPurple,
                        onPressed: () async {
                          //check network Availability

                          try {
                            var connectivityResult =
                                await (Connectivity().checkConnectivity());

                            if (connectivityResult == ConnectivityResult.none) {
                              showSnackBar('인터넷 연결이 없습니다. 연결 상태를 확인해주세요.');
                              return;
                            }

                            if (fullnameController.text.length < 3) {
                              showSnackBar('Please provide full name');
                              return;
                            }

                            if (!emailController.text.contains('@')) {
                              showSnackBar(
                                'Please provide a valid email address',
                              );
                              return;
                            }

                            if (phoneController.text.length < 10) {
                              showSnackBar(
                                'Please provide a valid phone number',
                              );
                              return;
                            }

                            if (passwordController.text.length < 8) {
                              showSnackBar(
                                'Password must be at least 8 characters',
                              );
                              return;
                            }
                            registerUser(context);
                          } catch (e) {
                            showSnackBar('An error occurred');
                          }
                        },
                      ),
                    ],
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Loginpage.id,
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Already have a DRIVER account? Log in',
                    style: TextStyle(color: Colors.black),
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
