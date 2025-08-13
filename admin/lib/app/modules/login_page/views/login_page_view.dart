import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/toast.dart';
import '../controllers/login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginPageController>(
      init: LoginPageController(),
      builder: (controller) {
        return ResponsiveWidget(
          mobile: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    50.height,
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/logo.png",
                            height: 50,
                            color: AppThemData.primary500,
                          ),
                          spaceW(),
                          const TextCustom(
                            title: 'My Taxi',
                            color: AppThemData.primary500,
                            fontSize: 30,
                            fontFamily: AppThemeData.semiBold,
                            fontWeight: FontWeight.w700,
                          )
                        ],
                      ),
                    ),
                    30.height,
                    TextCustom(
                      title: 'Unlock Your Admin \n Dashboard'.tr,
                      fontSize: 25,
                      maxLine: 2,
                      fontFamily: AppThemeData.bold,
                      // style: TextStyle(fontSize: 25, color: AppThemData.appColor, fontFamily: AppThemeData.bold, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          title: 'Email'.tr,
                          fontSize: 14,
                        ),
                        10.height,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                              style: TextStyle(color: AppThemData.primaryBlack, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                              autofocus: false,
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Please enter your email".tr);
                                }
                                // reg expression for email validatio
                                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                  return ("Please enter a valid email".tr);
                                }
                                return null;
                              },
                              onSaved: (value) {
                                // controller.emailController.text = value!;
                              },
                              textInputAction: TextInputAction.next,
                              cursorColor: AppThemData.appColor,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  size: 18,
                                  color: AppThemData.primaryBlack,
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                                hintText: "Enter your email".tr,
                                hintStyle: const TextStyle(color: AppThemData.gallery950, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                fillColor: AppThemData.primaryWhite,
                                filled: true,
                                isDense: true,
                                focusedBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: AppThemData.appColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          title: 'Password'.tr,
                          fontSize: 14,
                        ),
                        10.height,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Obx(
                            () => TextFormField(
                                style: TextStyle(color: AppThemData.primaryBlack, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                cursorColor: AppThemData.appColor,
                                autofocus: false,
                                controller: controller.passwordController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{6,}$');
                                  if (value!.isEmpty) {
                                    return ("Please enter your password".tr);
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("Enter valid password(Min. 6 Character)".tr);
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
                                textInputAction: TextInputAction.next,
                                obscureText: controller.isPasswordVisible.value,
                                decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                      },
                                      child: Icon(
                                        controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                                        color: AppThemData.lightGrey01,
                                      )),
                                  prefixIcon: Icon(
                                    Icons.password_outlined,
                                    color: AppThemData.primaryBlack,
                                  ),
                                  isDense: true,
                                  hintStyle: const TextStyle(color: AppThemData.gallery950, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                  contentPadding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                                  hintText: "Enter your password".tr,
                                  fillColor: AppThemData.primaryWhite,
                                  filled: true,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        //color: Colors.blue,
                                        ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (controller.emailController.value.text.isEmpty || controller.passwordController.value.text.isEmpty) {
                          ShowToast.errorToast("Please enter valid information.".tr);
                          return;
                        } else {
                          await controller.checkAndLoginOrCreateAdmin();
                        }
                        // Get.toNamed(Routes.HOME);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(color: AppThemData.primary500, borderRadius: BorderRadius.circular(16)),
                        child: Center(child: Text('LOGIN'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: AppThemeData.bold), textAlign: TextAlign.center)),
                      ),
                    ),
                    30.height,
                    loginCredential(controller),
                  ],
                ),
              ),
            ),
          ),
          desktop: Scaffold(
            body: Container(
                          color: AppThemData.primaryWhite,
                          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.70,
                decoration: const BoxDecoration(
                    color: Color(0xFFfff8f0),
                    image: DecorationImage(
                      image: AssetImage('assets/image/login.png'),
                    )),
              ),
              const SizedBox(
                width: 25,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                // color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/logo.png",
                            height: 50,
                            color: AppThemData.primary500,
                          ),
                          spaceW(),
                          const TextCustom(
                            title: 'My Taxi',
                            color: AppThemData.primary500,
                            fontSize: 30,
                            fontFamily: AppThemeData.semiBold,
                            fontWeight: FontWeight.w700,
                          )
                        ],
                      ),
                    ),
                    10.height,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextCustom(
                        title: 'Unlock Your Admin Dashboard'.tr,
                        fontSize: 25,
                        fontFamily: AppThemeData.bold,
                        color: AppThemData.primaryBlack,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        TextCustom(
                          title: 'Email ID'.tr,
                          fontSize: 14,
                        ),
                        5.height,
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: TextFormField(
                                style: TextStyle(color: AppThemData.primaryBlack, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                autofocus: false,
                                controller: controller.emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please enter your email".tr);
                                  }
                                  // reg expression for email validatio
                                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                    return ("Please enter a valid email".tr);
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                cursorColor: AppThemData.appColor,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    size: 18,
                                    color: AppThemData.primaryBlack,
                                  ),
                                  contentPadding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                                  hintText: "Enter your email".tr,
                                  hintStyle: const TextStyle(color: AppThemData.gallery950, fontSize: 14, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                  fillColor: AppThemData.primaryWhite,
                                  filled: true,
                                  isDense: true,
                                  focusedBorder: const OutlineInputBorder(
                                    // borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: AppThemData.appColor,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ))),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          title: 'Password'.tr,
                          fontSize: 14,
                        ),
                        10.height,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: Obx(
                            () => TextFormField(
                                style: TextStyle(color: AppThemData.primaryBlack, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                cursorColor: AppThemData.appColor,
                                autofocus: false,
                                controller: controller.passwordController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{6,}$');
                                  if (value!.isEmpty) {
                                    return ("Please enter your password".tr);
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("Enter valid password(Min. 6 Character)".tr);
                                  }
                                  return null;
                                },
                                // onFieldSubmitted: (value) async {
                                //   controller.checkLogin();
                                // },
                                onSaved: (value) {},
                                textInputAction: TextInputAction.next,
                                obscureText: controller.isPasswordVisible.value,
                                decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                      },
                                      child: Icon(
                                        controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                                        color: AppThemData.gallery500,
                                      )),
                                  prefixIcon: Icon(
                                    Icons.password_outlined,
                                    color: AppThemData.primaryBlack,
                                  ),
                                  isDense: true,
                                  hintStyle: const TextStyle(color: AppThemData.gallery950, fontSize: 14, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                  contentPadding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                                  hintText: "Enter your password".tr,
                                  fillColor: AppThemData.primaryWhite,
                                  filled: true,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        //color: Colors.blue,
                                        ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (controller.emailController.value.text.isEmpty || controller.passwordController.value.text.isEmpty) {
                          ShowToast.errorToast("Please enter valid information.".tr);
                          return;
                        } else {
                          await controller.checkAndLoginOrCreateAdmin();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.20,
                        decoration: BoxDecoration(color: AppThemData.primary500, borderRadius: BorderRadius.circular(10)),
                        child: Center(child: Text('LOGIN'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: AppThemeData.bold), textAlign: TextAlign.center)),
                      ),
                    ),
                    30.height,
                    loginCredential(controller),
                  ],
                ),
              ),
            ],
                          ),
                        ),
          ),
          tablet: Scaffold(
            body: Container(
                          color: AppThemData.primaryWhite,
                          child: Row(
            children: [
              Container(
                // height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.56,
                decoration: const BoxDecoration(
                    color: Color(0xFFfff8f0),
                    image: DecorationImage(
                      image: AssetImage('assets/image/login.png'),
                    )),
              ),
              // #fff8f0
              // Color(0xfff8f0)
              const SizedBox(
                width: 17,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                // color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/logo.png",
                            height: 50,
                            color: AppThemData.primary500,
                          ),
                          spaceW(),
                          const TextCustom(
                            title: 'My Taxi',
                            color: AppThemData.primary500,
                            fontSize: 30,
                            fontFamily: AppThemeData.semiBold,
                            fontWeight: FontWeight.w700,
                          )
                        ],
                      ),
                    ),
                    30.height,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextCustom(
                        title: 'Unlock Your Admin Dashboard'.tr,
                        fontSize: 16,
                        fontFamily: AppThemeData.bold,
                        color: AppThemData.primaryBlack,
                        // style: TextStyle(fontSize: 25, color: AppColors.appColor, fontFamily: AppThemeData.bold, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        TextCustom(
                          title: 'Email ID'.tr,
                          fontSize: 14,
                        ),
                        10.height,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          width: MediaQuery.of(context).size.width * 0.28,
                          child: TextFormField(
                              style: TextStyle(color: AppThemData.primaryBlack, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                              autofocus: false,
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Please enter your email".tr);
                                }
                                // reg expression for email validatio
                                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                  return ("Please enter a valid email".tr);
                                }
                                return null;
                              },
                              onSaved: (value) {
                                // controller.emailController.text = value!;
                              },
                              textInputAction: TextInputAction.next,
                              cursorColor: AppThemData.appColor,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  size: 18,
                                  color: AppThemData.primaryBlack,
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                                hintText: "Enter your email".tr,
                                hintStyle: const TextStyle(color: AppThemData.gallery950, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                fillColor: AppThemData.primaryWhite,
                                filled: true,
                                isDense: true,
                                focusedBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: AppThemData.appColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          title: 'Password'.tr,
                          fontSize: 14,
                        ),
                        10.height,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          width: MediaQuery.of(context).size.width * 0.28,
                          child: Obx(
                            () => TextFormField(
                                style: TextStyle(color: AppThemData.primaryBlack, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                cursorColor: AppThemData.appColor,
                                autofocus: false,
                                controller: controller.passwordController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{6,}$');
                                  if (value!.isEmpty) {
                                    return ("Please enter your password".tr);
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("Enter valid password(Min. 6 Character)".tr);
                                  }
                                  return null;
                                },
                                // onFieldSubmitted: (value) async {
                                //   controller.checkLogin();
                                // },
                                onSaved: (value) {},
                                textInputAction: TextInputAction.next,
                                obscureText: controller.isPasswordVisible.value,
                                decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                      },
                                      child: Icon(
                                        controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                                        color: AppThemData.lightGrey01,
                                      )),
                                  prefixIcon: Icon(
                                    Icons.password_outlined,
                                    color: AppThemData.primaryBlack,
                                  ),
                                  isDense: true,
                                  hintStyle: const TextStyle(color: AppThemData.gallery950, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                  contentPadding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                                  hintText: "Enter your password".tr,
                                  fillColor: AppThemData.primaryWhite,
                                  filled: true,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        //color: Colors.blue,
                                        ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (controller.emailController.value.text.isEmpty || controller.passwordController.value.text.isEmpty) {
                          ShowToast.errorToast("Please enter valid information.".tr);
                          return;
                        } else {
                          await controller.checkAndLoginOrCreateAdmin();
                        } // Get.toNamed(Routes.HOME);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.28,
                        decoration: BoxDecoration(color: AppThemData.primary500, borderRadius: BorderRadius.circular(16)),
                        child: Center(child: Text('LOGIN'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: AppThemeData.bold), textAlign: TextAlign.center)),
                      ),
                    ),
                    30.height,
                    loginCredential(controller),
                  ],
                ),
              ),
            ],
                          ),
                        ),
          ),
        );
      },
    );
  }

  Widget loginCredential(LoginPageController controller) {
    return SizedBox();
  }
}
