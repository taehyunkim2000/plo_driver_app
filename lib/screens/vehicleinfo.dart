import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plo_driver_app/brand_colors.dart';
import 'package:plo_driver_app/widgets/taxi_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plo_driver_app/screens/mainpage.dart';

class VehicleInfoPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void showSnackBar(String title, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static const String id = 'vehicleinfo';

  var carModelController = TextEditingController();
  var carColorController = TextEditingController();
  var vehicleNumberController = TextEditingController();

  VehicleInfoPage({super.key});

  void updateProfile(BuildContext context) {
    String id = FirebaseAuth.instance.currentUser!.uid;

    DatabaseReference driverRef = FirebaseDatabase.instance.ref().child(
      'drivers/$id/vehicle_details',
    );

    Map map = {
      'car_color': carColorController.text,
      'car_model': carModelController.text,
      'vehicle_number': vehicleNumberController.text,
    };

    driverRef.set(map);

    Navigator.pushNamedAndRemoveUntil(context, Mainpage.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Image.asset('images/logo.png', height: 110, width: 110),

              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                child: Column(
                  children: [
                    SizedBox(height: 10),

                    Text(
                      'Enter vehicle details',
                      style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 22),
                    ),

                    SizedBox(height: 25),

                    TextField(
                      controller: carModelController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Car model',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),

                    SizedBox(height: 10),

                    TextField(
                      controller: carColorController,
                      decoration: InputDecoration(
                        hintText: 'Car color',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),

                    SizedBox(height: 10),

                    TextField(
                      controller: vehicleNumberController,
                      maxLength: 11,
                      decoration: InputDecoration(
                        hintText: 'Vehicle number',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),

                    SizedBox(height: 40),

                    TaxiButton(
                      title: 'PROCEED',
                      color: BrandColors.colorGreen,
                      onPressed: () {
                        if (carModelController.text.length < 3) {
                          showSnackBar(
                            'Please enter a valid car model',
                            context,
                          );
                          return;
                        }

                        if (carColorController.text.length < 3) {
                          showSnackBar(
                            'Please enter a valid car color',
                            context,
                          );
                          return;
                        }

                        if (vehicleNumberController.text.length < 3) {
                          showSnackBar(
                            'Please enter a valid vehicle number',
                            context,
                          );
                          return;
                        }

                        updateProfile(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
