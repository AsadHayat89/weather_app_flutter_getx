import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/components/custom_icon_button.dart';
import 'package:weather_app/app/modules/home/views/widgets/home_shimmer.dart';
import 'package:weather_app/app/routes/app_pages.dart';
import 'package:weather_app/config/font_style.dart';

import '../../../../config/strings_enum.dart';
import '../controllers/home_controller.dart';
import 'widgets/weather_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: GetBuilder<HomeController>(
            builder: (_) => controller.apiCalled == true
                ? ListView(
                    children: [
                      20.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.discoverTheWeather.tr,
                                  style: FontClass.displayMedium(Colors.black)
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.sp),
                                ),
                              ],
                            ),
                          ),
                          CustomIconButton(
                            onPressed: () {
                              Get.toNamed(Routes.GALLERY);
                            },
                            icon: GetBuilder<HomeController>(
                              id: controller.themeId,
                              builder: (_) => Icon(
                                Icons.image,
                                color: theme.iconTheme.color,
                              ),
                            ),
                            borderColor: theme.dividerColor,
                          ),
                        ],
                      ).animate().fade().slideX(
                            duration: 300.ms,
                            begin: -1,
                            curve: Curves.easeInSine,
                          ),
                      24.verticalSpace,
                      if (controller.apiCalled == true)
                        SizedBox(
                            height: 170.h,
                            child: CarouselSlider.builder(
                              disableGesture: true,
                              options: CarouselOptions(
                                enableInfiniteScroll: false,
                                viewportFraction: 1.0,
                                pageSnapping: false,
                                enlargeCenterPage: false,
                                onPageChanged: controller.onCardSlided,
                              ),
                              itemCount: 1,
                              itemBuilder: (context, itemIndex, pageViewIndex) {
                                return WeatherCard(
                                    weather: controller.currentWeather);
                              },
                            )),
                      24.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Strings.aroundTheWorld.tr,
                            style: FontClass.displayMedium(Colors.black)
                                .copyWith(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: (){
                             controller.moveToMap();
                            },
                            child: Text(
                              Strings.addLocation.tr,
                              style: FontClass.displayMedium(Colors.blueAccent)
                                  .copyWith(fontSize: 18.sp),
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.weatherArroundTheWorld.length,
                        separatorBuilder: (context, index) => 16.verticalSpace,
                        itemBuilder: (context, index) => WeatherCard(
                          weather: controller.weatherArroundTheWorld[index],
                        ).animate(delay: (100 * index).ms).fade().slideY(
                              duration: 300.ms,
                              begin: 1,
                              curve: Curves.easeInSine,
                            ),
                      ),
                      24.verticalSpace,
                    ],
                  )
                : HomeShimmer(),
          ),
        ),
      ),
    );
  }
}
