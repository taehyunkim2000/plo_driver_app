import 'package:flutter/material.dart';

class AvailabilityButton extends StatelessWidget {
  final String title;
  final Color color;
  final void Function() onPressed;

  const AvailabilityButton({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Container(
        height: 50,
        width: 200,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),
          ),
        ),
      ),
    );
  }
}
