import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<ChangePasswordController>(
      init: ChangePasswordController(),
      builder: (controller) {
        // Check if user can change password (only for email/password accounts)
        if (!controller.isEmailUser) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(
              title: "Change Password".tr,
              bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 80,
                      color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Password Change Not Available".tr,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "You signed up using Google or Apple. Password changes are not available for social login accounts."
                          .tr,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            bool isFocus = FocusScope.of(context).hasFocus;
            if (isFocus) {
              FocusScope.of(context).unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(
              title: "Change Password".tr,
              bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            ),
            body: Container(
              width: Responsive.width(100, context),
              height: Responsive.height(100, context),
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Security".tr,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Update your password to keep your account secure".tr,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: controller.formKey.value,
                      child: Column(
                        children: [
                          // Current Password Field
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppThemData.grey100),
                            ),
                            child: TextFormField(
                              cursorColor: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                              obscureText: !controller.isCurrentPasswordVisible.value,
                              controller: controller.currentPasswordController,
                              validator: controller.validateCurrentPassword,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                                hintText: "Current password".tr,
                                hintStyle: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    controller.toggleCurrentPasswordVisibility();
                                  },
                                  child: Icon(
                                    controller.isCurrentPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                                    color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // New Password Field
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppThemData.grey100),
                            ),
                            child: TextFormField(
                              cursorColor: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                              obscureText: !controller.isNewPasswordVisible.value,
                              controller: controller.newPasswordController,
                              validator: controller.validateNewPassword,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                                hintText: "New password".tr,
                                hintStyle: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    controller.toggleNewPasswordVisibility();
                                  },
                                  child: Icon(
                                    controller.isNewPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
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
                                hintText: "Confirm new password".tr,
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

                          // Password Requirements Info
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey50,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Password requirements:".tr,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildRequirement("• At least 6 characters".tr, themeChange),
                                _buildRequirement("• Different from current password".tr, themeChange),
                              ],
                            ),
                          ),

                          // Update Password Button
                          RoundShapeButton(
                            size: const Size(double.infinity, 50),
                            title: "Update Password".tr,
                            buttonColor: AppThemData.primary500,
                            buttonTextColor: AppThemData.black,
                            onTap: () {
                              if (controller.formKey.value.currentState!.validate()) {
                                controller.changePassword();
                              } else {
                                ShowToastDialog.showToast('Please fill all fields correctly'.tr);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequirement(String text, DarkThemeProvider themeChange) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600,
        ),
      ),
    );
  }
}
