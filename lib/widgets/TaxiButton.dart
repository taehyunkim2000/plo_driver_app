import 'package:flutter/material.dart';

class TaxiButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;

  const TaxiButton({
    super.key,
    required this.text,
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
      onPressed: onPressed as VoidCallback,
      child: SizedBox(
        height: 50,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
          ),
        ),
      ),
    );
  }
}
