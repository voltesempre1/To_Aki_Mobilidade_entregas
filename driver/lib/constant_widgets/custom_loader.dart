import 'package:driver/theme/app_them_data.dart';
import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final double size;

  const CustomLoader({this.size = 30, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppThemData.blueLight),
          strokeWidth: 3, // Adjust thickness
        ),

      ),
    );
  }
}
