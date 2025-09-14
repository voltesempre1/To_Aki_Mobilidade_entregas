import 'dart:io';

import 'package:customer/constant_widgets/country_code_selector_view.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/validate_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../theme/responsive.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<LoginController>(
        init: LoginController(),
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
                  backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                  automaticallyImplyLeading: false),
              body: Container(
                width: Responsive.width(100, context),
                height: Responsive.height(100, context),
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Center(
                            child: SvgPicture.asset(themeChange.isDarkTheme()
                                ? "assets/icon/splash_logo.svg"
                                : "assets/icon/logo_black.svg")),
                      ),
                      Text(
                        "Login".tr,
                        style: GoogleFonts.inter(
                            fontSize: 24,
                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Please login to continue".tr,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                            fontWeight: FontWeight.w400),
                      ),

                      // Toggle between login methods
                      Container(
                        margin: const EdgeInsets.only(top: 24, bottom: 16),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey50,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.toggleLoginMethod(0);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: controller.selectedLoginMethod.value == 0
                                        ? AppThemData.primary500
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    "Phone".tr,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: controller.selectedLoginMethod.value == 0
                                          ? AppThemData.white
                                          : (themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.toggleLoginMethod(1);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: controller.selectedLoginMethod.value == 1
                                        ? AppThemData.primary500
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    "Email".tr,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: controller.selectedLoginMethod.value == 1
                                          ? AppThemData.white
                                          : (themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Phone Login Form
                      Visibility(
                        visible: controller.selectedLoginMethod.value == 0,
                        child: Container(
                          height: 110,
                          width: Responsive.width(100, context),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12), border: Border.all(color: AppThemData.grey100)),
                          child: Form(
                            key: controller.formKey.value,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 45,
                                  padding: const EdgeInsets.all(8.0),
                                  child: CountryCodeSelectorView(
                                    isCountryNameShow: true,
                                    countryCodeController: controller.countryCodeController,
                                    isEnable: true,
                                    onChanged: (value) {
                                      controller.countryCodeController.text = value.dialCode.toString();
                                    },
                                  ),
                                ),
                                const Divider(color: AppThemData.grey100),
                                SizedBox(
                                  height: 45,
                                  child: TextFormField(
                                    cursorColor: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                    keyboardType: TextInputType.number,
                                    controller: controller.phoneNumberController,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                    ],
                                    validator: (value) =>
                                        validateMobile(value, controller.countryCodeController.value.text),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 15),
                                      hintText: "Enter your Phone Number".tr,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Email Login Form
                      Visibility(
                        visible: controller.selectedLoginMethod.value == 1,
                        child: Form(
                          key: controller.emailFormKey.value,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppThemData.grey100)),
                                child: TextFormField(
                                  cursorColor: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: controller.emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your email".tr;
                                    }
                                    if (!GetUtils.isEmail(value)) {
                                      return "Please enter a valid email".tr;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(16),
                                    hintText: "Enter your email".tr,
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppThemData.grey100)),
                                child: TextFormField(
                                  cursorColor: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                  obscureText: !controller.isPasswordVisible.value,
                                  controller: controller.passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your password".tr;
                                    }
                                    if (value.length < 6) {
                                      return "Password must be at least 6 characters".tr;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(16),
                                    hintText: "Enter your password".tr,
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

                              // Forgot Password Link
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    controller.goToForgotPassword();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      "Forgot Password?".tr,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: AppThemData.primary500,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Action Button
                      RoundShapeButton(
                        size: Size(MediaQuery.of(context).size.width - 40, 50),
                        title: controller.selectedLoginMethod.value == 0 ? "Send OTP".tr : "Login".tr,
                        buttonColor: AppThemData.primary500,
                        buttonTextColor: AppThemData.white,
                        onTap: () {
                          if (controller.selectedLoginMethod.value == 0) {
                            if (controller.formKey.value.currentState!.validate()) {
                              controller.sendCode();
                            } else {
                              ShowToastDialog.showToast('Please enter a valid number'.tr);
                            }
                          } else {
                            if (controller.emailFormKey.value.currentState!.validate()) {
                              controller.loginWithEmail();
                            } else {
                              ShowToastDialog.showToast('Please fill all fields correctly'.tr);
                            }
                          }
                        },
                      ),

                      // Sign up button
                      const SizedBox(height: 20),
                      Center(
                        child: InkWell(
                          onTap: () {
                            controller.goToSignup();
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Don't have an account?".tr,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(width: 5),
                                ),
                                TextSpan(
                                  text: "Sign Up".tr,
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

                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 52,
                              margin: const EdgeInsets.only(right: 10),
                              child: const Divider(color: AppThemData.grey100),
                            ),
                            Text(
                              "Continue with".tr,
                              style: GoogleFonts.inter(
                                  fontSize: 12, color: AppThemData.grey400, fontWeight: FontWeight.w400),
                            ),
                            Container(
                              width: 52,
                              margin: const EdgeInsets.only(left: 10),
                              child: const Divider(color: AppThemData.grey100),
                            ),
                          ],
                        ),
                      ),
                      // Social Login Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Visibility(
                            visible: Platform.isIOS,
                            child: Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: () {
                                    controller.loginWithApple();
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey100,
                                        )),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icon/ic_apple.svg",
                                          height: 24,
                                          width: 24,
                                          colorFilter: ColorFilter.mode(
                                              themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                              BlendMode.srcIn),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Apple'.tr,
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: Platform.isIOS ? 8 : 0),
                              child: InkWell(
                                onTap: () {
                                  controller.loginWithGoogle();
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey100,
                                      )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/icon/ic_google.svg", height: 24, width: 24),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Google'.tr,
                                        style: GoogleFonts.inter(
                                          color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
