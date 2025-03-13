import 'package:flutter/material.dart';
import 'package:plo_driver_app/datamodels/tripdetails.dart';

class NewTripPage extends StatefulWidget {
  final TripDetails? tripDetails;
  const NewTripPage({super.key, required this.tripDetails});

  @override
  State<NewTripPage> createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('New Trip')));
  }
}
