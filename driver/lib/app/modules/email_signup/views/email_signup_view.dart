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

import '../controllers/email_signup_controller.dart';

class EmailSignupView extends StatelessWidget {
  const EmailSignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<EmailSignupController>(
      init: EmailSignupController(),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Text(
                      "Create Account".tr,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Please fill in the information to create your account".tr,
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
                            margin: const EdgeInsets.only(bottom: 16),
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
                          
                          // Password Field
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppThemData.grey100),
                            ),
                            child: TextFormField(
                              cursorColor: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                              obscureText: !controller.isPasswordVisible.value,
                              controller: controller.passwordController,
                              validator: controller.validatePassword,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                                hintText: "Enter your password".tr,
                                hintStyle: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    controller.togglePasswordVisibility();
                                  },
                                  child: Icon(
                                    controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                                    color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Confirm Password Field
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppThemData.grey100),
                            ),
                            child: TextFormField(
                              cursorColor: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                              obscureText: !controller.isConfirmPasswordVisible.value,
                              controller: controller.confirmPasswordController,
                              validator: controller.validateConfirmPassword,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                                hintText: "Confirm your password".tr,
                                hintStyle: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    controller.toggleConfirmPasswordVisibility();
                                  },
                                  child: Icon(
                                    controller.isConfirmPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                                    color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Sign Up Button
                          RoundShapeButton(
                            size: const Size(double.infinity, 50),
                            title: "Create Account".tr,
                            buttonColor: AppThemData.primary500,
                            buttonTextColor: AppThemData.black,
                            onTap: () {
                              if (controller.formKey.value.currentState!.validate()) {
                                controller.signupWithEmail();
                              } else {
                                ShowToastDialog.showToast('Please fill all fields correctly'.tr);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Login Link
                    Center(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account? ".tr,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: "Login".tr,
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
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}