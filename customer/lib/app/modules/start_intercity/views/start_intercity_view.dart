import 'package:customer/app/modules/book_intercity/views/book_intercity_view.dart';
import 'package:customer/constant_widgets/app_bar_with_border.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/start_intercity_controller.dart';

class StartIntercityView extends GetView<StartIntercityController> {
  const StartIntercityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBorder(title: "", bgColor: AppThemData.primary500,isUnderlineShow: false,),
      body: Container(
        width: Responsive.width(100, context),
        height: Responsive.height(100, context),
        color: AppThemData.primary500,
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              margin: const EdgeInsets.only(top: 82, bottom: 24),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/icon/gif_intercity_path.gif"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Text(
              'My Taxi Intercity'.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppThemData.grey950,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(48, 24, 42, 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset("assets/icon/ic_intercity_one.svg"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'For long distance trip between select cities'.tr,
                      style: GoogleFonts.inter(
                        color: AppThemData.grey950,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(48, 0, 42, 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset("assets/icon/ic_intercity_two.svg"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Convenient and affordable rides'.tr,
                      style: GoogleFonts.inter(
                        color: AppThemData.grey950,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(48, 0, 42, 24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset("assets/icon/ic_intercity_three.svg"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Priority chat support post trip'.tr,
                      style: GoogleFonts.inter(
                        color: AppThemData.grey950,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RoundShapeButton(
                size: const Size(200, 45),
                title: "Get Started".tr,
                buttonColor: AppThemData.white,
                buttonTextColor: AppThemData.black,
                onTap: () {
                  Get.to(const BookIntercityView());
                }),
          ],
        ),
      ),
    );
  }
}
