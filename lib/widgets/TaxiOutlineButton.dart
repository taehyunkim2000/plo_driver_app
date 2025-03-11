import 'package:flutter/material.dart';
import 'package:plo_driver_app/brand_colors.dart';

class TaxiOutlineButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final Color color;

  const TaxiOutlineButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        height: 50.0,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'Brand-Bold',
              color: BrandColors.colorText,
            ),
          ),
        ),
      ),
    );
  }
}
