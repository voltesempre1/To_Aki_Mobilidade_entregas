// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDialogBox extends StatelessWidget {
  final String title, descriptions, positiveString, negativeString;
  final Widget img;
  final Function() positiveClick;
  final Function() negativeClick;
  final DarkThemeProvider themeChange;
  final Color? negativeButtonColor;
  final Color? positiveButtonColor;
  final Color? negativeButtonTextColor;
  final Color? positiveButtonTextColor;

  const CustomDialogBox(
      {super.key,
      required this.title,
      required this.descriptions,
      required this.img,
      required this.positiveClick,
      required this.negativeClick,
      required this.positiveString,
      required this.negativeString,
      required this.themeChange,
      this.negativeButtonColor,
      this.positiveButtonColor,
      this.negativeButtonTextColor,
      this.positiveButtonTextColor});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Container contentBox(context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(shape: BoxShape.rectangle, color: themeChange.isDarkTheme() ? Colors.black : Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          img,
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: title.isNotEmpty,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 20, color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Visibility(
            visible: descriptions.isNotEmpty,
            child: Text(
              descriptions,
              style: GoogleFonts.inter(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    negativeClick();
                  },
                  child: Container(
                    width: Responsive.width(100, context),
                    height: 45,
                    decoration: ShapeDecoration(
                      color: negativeButtonColor ?? AppThemData.danger500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          negativeString.toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: negativeButtonTextColor ?? AppThemData.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    positiveClick();
                  },
                  child: Container(
                    width: Responsive.width(100, context),
                    height: 45,
                    decoration: ShapeDecoration(
                      color: positiveButtonColor ?? AppThemData.primary500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          positiveString.toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: positiveButtonTextColor ?? AppThemData.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ActiveRideDialog extends StatelessWidget {
  final DarkThemeProvider themeChange;
  const ActiveRideDialog({super.key, required this.themeChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
          color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Already Have an Active Ride",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: themeChange.isDarkTheme() ? AppThemData.grey100 : AppThemData.grey900),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "Please Complete your current active ride before starting a new ride booking.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey800),
          ),
          SizedBox(
            height: 12,
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: InkWell(
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //     child: Text(
          //       "Ok",
          //       style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: AppThemData.primary500),
          //     ),
          //   )
          // )
        ],
      ),
    );
  }
}
