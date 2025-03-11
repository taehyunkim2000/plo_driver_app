import 'package:flutter/material.dart';
import 'package:plo_driver_app/brand_colors.dart';
import 'package:plo_driver_app/widgets/TaxiOutlineButton.dart';
import 'package:plo_driver_app/widgets/taxi_button.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function() onPressed;

  const ConfirmSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      height: 220,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Brand-Bold',
                color: BrandColors.colorText,
              ),
            ),
            SizedBox(height: 20),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: BrandColors.colorTextLight),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: TaxiOutlineButton(
                    title: 'BACK',
                    color: BrandColors.colorLightGrayFair,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TaxiButton(
                    title: 'CONFIRM',
                    color:
                        (title == 'GO ONLINE')
                            ? BrandColors.colorGreen
                            : Colors.red,
                    onPressed: onPressed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
