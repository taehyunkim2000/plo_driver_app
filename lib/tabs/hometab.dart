import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plo_driver_app/brand_colors.dart';
import 'package:plo_driver_app/widgets/AvailibityButton.dart';
import 'package:plo_driver_app/widgets/ConfirmSheet.dart';
import 'package:plo_driver_app/widgets/taxi_button.dart';
import '../globalVariables.dart';

class Hometab extends StatefulWidget {
  const Hometab({super.key});

  @override
  State<Hometab> createState() => _HometabState();
}

class _HometabState extends State<Hometab> {
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();
  Position? currentPosition;

  late DatabaseReference tripRequestRef;

  String availabiltyTitle = 'GO ONLINE';
  Color availabilityColor = BrandColors.colorOrange;

  bool isAvailable = false;

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      currentPosition = position;
      LatLng latLng = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(latLng));
    } catch (e) {
      debugPrint("Error getting current location: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          padding: EdgeInsets.only(top: 135),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: googlePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;

            getCurrentLocation();
          },
        ),
        Container(
          height: 135,
          width: double.infinity,
          color: BrandColors.colorPrimary,
        ),

        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AvailabilityButton(
                title: availabiltyTitle,
                color: availabilityColor,
                onPressed: () {
                  //goOnline();
                  //getLocationUpdates();

                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder:
                        (BuildContext context) => ConfirmSheet(
                          title: (isAvailable) ? 'GO OFFLINE' : 'GO ONLINE',
                          subtitle:
                              (!isAvailable)
                                  ? 'You are about to become available to receive trip requests'
                                  : 'you will stop receiving new trip requests',

                          onPressed: () {
                            if (!isAvailable) {
                              goOnline();
                              getLocationUpdates();
                              Navigator.pop(context);

                              setState(() {
                                availabilityColor = BrandColors.colorGreen;
                                availabiltyTitle = 'GO OFFLINE';
                                isAvailable = true;
                              });
                            } else {
                              goOffline();
                              Navigator.pop(context);

                              setState(() {
                                availabilityColor = BrandColors.colorOrange;
                                availabiltyTitle = 'GO ONLINE';
                                isAvailable = false;
                              });
                            }
                          },
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void goOnline() {
    Geofire.initialize("driversAvailable");
    Geofire.setLocation(
      currentFirebaseUser!.uid,
      currentPosition!.latitude,
      currentPosition!.longitude,
    );

    tripRequestRef = FirebaseDatabase.instance.ref().child(
      "drivers/${currentFirebaseUser!.uid}/newtrip",
    );
    tripRequestRef.set('waiting');

    tripRequestRef.onValue.listen((event) {});
  }

  void goOffline() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    homeTabPositionStream?.cancel();
  }

  void getLocationUpdates() {
    homeTabPositionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 4,
      ),
    ).listen((Position position) {
      currentPosition = position;
      if (isAvailable) {
        Geofire.setLocation(
          currentFirebaseUser!.uid,
          position.latitude,
          position.longitude,
        );
      }

      LatLng latLng = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}
