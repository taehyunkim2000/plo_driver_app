import 'package:flutter/material.dart'; // 그전 섹션에서 datamodels->tripdetails 파일 만드는듯
import 'package:plo_driver_app/brand_colors.dart';
import 'package:plo_driver_app/datamodels/tripdetails.dart';
import 'package:plo_driver_app/globalVariables.dart';
import 'package:plo_driver_app/screens/newtripspage.dart';
import 'package:plo_driver_app/widgets/BrandDriver.dart';
import 'package:plo_driver_app/widgets/ProgressDialog.dart';
import 'package:plo_driver_app/widgets/TaxiOutlineButton.dart';
import 'package:plo_driver_app/widgets/taxi_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toast/toast.dart';

class NotificationDialog extends StatelessWidget {
  final TripDetails? tripDetails;

  const NotificationDialog({super.key, required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 30.0),

            Image.asset('images/taxi.png', width: 100),

            SizedBox(height: 10.0),

            Text(
              'NEW TRIP REQUEST',
              style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 18),
            ),

            SizedBox(height: 30.0),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('images/pickicon.png', width: 16, height: 16),
                      SizedBox(width: 18),

                      Expanded(
                        child: Container(
                          child: Text(
                            tripDetails?.pickupAddress ?? '',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('images/desticon.png', width: 16, height: 16),
                      SizedBox(width: 18),

                      Expanded(
                        child: Container(
                          child: Text(
                            tripDetails?.destinationAddress ?? '',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            BrandDivider(),

            SizedBox(height: 8),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: TaxiOutlineButton(
                        title: 'DECLINE',
                        color: BrandColors.colorPrimary,
                        onPressed: () async {
                          assetsAudioPlayer.stop();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Container(
                      child: TaxiButton(
                        title: 'ACCEPT',
                        color: BrandColors.colorGreen,
                        onPressed: () async {
                          assetsAudioPlayer.stop();
                          checkAvailability(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  void checkAvailability(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (BuildContext context) => ProgressDialog(status: 'Accepting request'),
    );

    DatabaseReference newRideRef = FirebaseDatabase.instance.ref().child(
      'drivers/${currentFirebaseUser!.uid}',
    );
    newRideRef.once().then((DatabaseEvent event) {
      Navigator.pop(context);
      Navigator.pop(
        context,
      ); // 뭔가 안되면 이 두개의 Nvigator.pop 을 final DataSnapshot snapshot = event.snapshot; 아래에 써보기
      final DataSnapshot snapshot = event.snapshot;

      String thisRideID = "";
      if (snapshot.value != null) {
        thisRideID = snapshot.value.toString();
      } else {
        Toast.show(
          "Ride not found",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
      }

      if (thisRideID == tripDetails?.rideID) {
        newRideRef.set('accepted');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewTripPage(tripDetails: tripDetails),
          ),
        );
      } else if (thisRideID == 'cancelled') {
        Toast.show(
          "Ride has been cancelled",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
      } else if (thisRideID == 'timeout') {
        Toast.show(
          "Ride has timed oup",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
      } else {
        Toast.show(
          "Ride not found",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
      }
    });
  }
}
