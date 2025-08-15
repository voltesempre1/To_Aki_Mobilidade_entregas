import 'package:admin/app/global_controller.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreenView extends GetView<GlobalController> {
  const SplashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: GlobalController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppThemData.primaryWhite,
          body: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: 300,
              child: Image.asset(
                "assets/animation/cab_animation.gif",
              ),
            ),
          ),
        );
      },
    );
  }
}
