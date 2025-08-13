import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/app/models/review_customer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/app/modules/home/controllers/home_controller.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/constant_widgets/star_rating.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReviewScreenView extends GetView<HomeController> {
  const ReviewScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
          appBar: AppBarWithBorder(
            title: "Customer Reviews".tr,
            bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
          ),
          body: controller.isLoading.value
              ? Constant.loader()
              : Obx(
                  () => controller.reviewList.isEmpty
                      ? Center(
                          child: Text(
                            "No Available Customer Review",
                            style: GoogleFonts.inter(
                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.reviewList.length,
                          itemBuilder: (context, index) {
                            ReviewModel reviewModel = controller.reviewList[index];
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                              decoration: ShapeDecoration(
                                color: themeChange.isDarkTheme() ? controller.colorDark[index % 4] : controller.color[index % 4],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      FutureBuilder<UserModel?>(
                                        future: FireStoreUtils.getUserProfile(reviewModel.customerId.toString()),
                                        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const SizedBox();
                                          }
                                          UserModel? userModel = snapshot.data ?? UserModel();
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                              imageUrl: userModel.profilePic ?? Constant.profileConstant,
                                              errorWidget: (context, url, error) {
                                                return Container(
                                                  width: 40,
                                                  height: 40,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: ShapeDecoration(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(200),
                                                    ),
                                                    color: AppThemData.white,
                                                    image: const DecorationImage(
                                                      image: NetworkImage(Constant.profileConstant),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder<UserModel?>(
                                            future: FireStoreUtils.getUserProfile(reviewModel.customerId.toString()),
                                            builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return const SizedBox();
                                              }
                                              UserModel? userModel = snapshot.data ?? UserModel();
                                              return Text(
                                                userModel.fullName ?? "",
                                                style: GoogleFonts.inter(
                                                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 4),
                                          StarRating(
                                            onRatingChanged: (rating) {},
                                            color: AppThemData.warning500,
                                            starCount: 5,
                                            rating: reviewModel.rating != null ? double.tryParse(reviewModel.rating.toString()) ?? 0.0 : 0.0,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    reviewModel.comment.toString(),
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
        );
      },
    );
  }
}
