import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

late User? currentFirebaseUser;
// late DatabaseReference tripRequestRef;

final CameraPosition googlePlex = const CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

String mapKey = 'AIzaSyAknGQdA7yAS5SICTW8lOKilEN7FBpNS-U';

StreamSubscription<Position>? homeTabPositionStream;

final audioPlayer = AudioPlayer();
