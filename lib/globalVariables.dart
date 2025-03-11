import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

late FirebaseAuth currentFirebaseUser;

final CameraPosition googlePlex = const CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

String mapKey = 'AIzaSyAknGQdA7yAS5SICTW8lOKilEN7FBpNS-U';
