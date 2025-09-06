import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<ForgotPasswordController>(
      init: ForgotPasswordController(),
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            bool isFocus = FocusScope.of(context).hasFocus;
            if (isFocus) {
              FocusScope.of(context).unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: themeChange.isDarkTheme() ? AppThemData.grey600 : AppThemData.grey100),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                  ),
                ),
              ),
            ),
            body: Container(
              width: Responsive.width(100, context),
              height: Responsive.height(100, context),
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Center(
                        child: SvgPicture.asset(
                          themeChange.isDarkTheme() ? "assets/icon/splash_logo.svg" : "assets/icon/splash_logo.svg",
                          height: 75,
                          width: 75,
                        ),
                      ),
                    ),

                    // Content based on state
                    controller.emailSent.value
                        ? _buildEmailSentView(context, controller, themeChange)
                        : _buildEmailInputView(context, controller, themeChange),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmailInputView(
      BuildContext context, ForgotPasswordController controller, DarkThemeProvider themeChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Forgot Password?".tr,
          style: GoogleFonts.inter(
            fontSize: 24,
            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "Enter your email address and we'll send you a password reset link".tr,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 32),

        Form(
          key: controller.formKey.value,
          child: Column(
            children: [
              // Email Field
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppThemData.grey100),
                ),
                child: TextFormField(
                  cursorColor: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailController,
                  validator: controller.validateEmail,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    hintText: "Enter your email".tr,
                    hintStyle: GoogleFonts.inter(
                      color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                    ),
                  ),
                ),
              ),

              // Send Reset Email Button
              RoundShapeButton(
                size: const Size(double.infinity, 50),
                title: "Send Reset Email".tr,
                buttonColor: AppThemData.primary500,
                buttonTextColor: AppThemData.black,
                onTap: () {
                  if (controller.formKey.value.currentState!.validate()) {
                    controller.sendPasswordResetEmail(); // Using corrected method without ActionCodeSettings
                  } else {
                    ShowToastDialog.showToast('Please enter a valid email'.tr);
                  }
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Back to Login Link
        Center(
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Remember your password? ".tr,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: "Back to Login".tr,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppThemData.primary500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailSentView(BuildContext context, ForgotPasswordController controller, DarkThemeProvider themeChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Success Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: AppThemData.success50,
          ),
          child: Icon(
            Icons.mark_email_read_outlined,
            size: 50,
            color: AppThemData.success500,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          "Check Your Email".tr,
          style: GoogleFonts.inter(
            fontSize: 24,
            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        Text(
          "We sent a password reset link to".tr,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          controller.emailController.text,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        // Instructions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Next steps:".tr,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "1. Check your email inbox".tr,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "2. Click the reset password link".tr,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "3. Create your new password".tr,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Resend Email Button
        RoundShapeButton(
          size: const Size(double.infinity, 50),
          title: "Resend Email".tr,
          buttonColor: AppThemData.primary500,
          buttonTextColor: AppThemData.black,
          onTap: () {
            controller.resendEmail();
          },
        ),

        const SizedBox(height: 16),

        // Back to Login Button
        RoundShapeButton(
          size: const Size(double.infinity, 50),
          title: "Back to Login".tr,
          buttonColor: Colors.transparent,
          buttonTextColor: AppThemData.primary500,
          onTap: () {
            controller.backToLogin();
          },
        ),
      ],
    );
  }
}
