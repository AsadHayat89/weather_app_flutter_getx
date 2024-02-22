import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/components/custom_button.dart';
import 'package:weather_app/app/modules/weather/views/widgets/shimmer_widget.dart';
import 'package:weather_app/config/font_style.dart';
import 'package:screenshot/screenshot.dart';
import '../../../../config/strings_enum.dart';
import '../../../../utils/extensions.dart';
import '../../../components/custom_icon_button.dart';
import '../controllers/weather_controller.dart';
import 'widgets/forecast_hour_item.dart';
import 'widgets/sun_rise_set_item.dart';
import 'widgets/weather_details_card.dart';
import 'widgets/weather_row_data.dart';

class WeatherView extends GetView<WeatherController> {
  const WeatherView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return WillPopScope(
      onWillPop: () async {
        print("data received her");
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: GetBuilder<WeatherController>(
            builder: (_) => controller.isApiCalled.value == true
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        30.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 26.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomIconButton(
                                onPressed: () => Get.back(),
                                icon: const Icon(Icons.arrow_back_rounded,
                                    color: Colors.white),
                                backgroundColor: theme.primaryColor,
                              ),
                              CustomButton(
                                onPressed: (){
                                  controller.takeScreenshot();
                                },
                                text: Strings.capture.tr,
                                fontSize: 18.sp,
                                backgroundColor: theme.primaryColor,
                                foregroundColor: Colors.white,
                                width: 140.w,
                                radius: 30.r,
                                verticalPadding: 10.h,
                              )
                            ],
                          ),
                        ),
                        24.verticalSpace,
                        Screenshot(
                          controller:controller.screenshotController,
                          child: AspectRatio(
                            aspectRatio: 0.99,
                            child: PageView.builder(
                              controller: controller.pageController,
                              // physics: const ClampingScrollPhysics(),
                              onPageChanged: controller.onCardSlided,
                              itemCount: controller
                                  .weatherDetails.forecast.forecastday.length,
                              itemBuilder: (context, index) {
                                return WeatherDetailsCard(
                                  weatherDetails: controller.weatherDetails,
                                  forecastDay: controller
                                      .weatherDetails.forecast.forecastday[index],
                                  index: index,
                                );
                              },
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: theme.canvasColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.r),
                              topRight: Radius.circular(30.r),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              20.verticalSpace,
                              Text(Strings.hoursForecast.tr,
                                  style: FontClass.displayMedium(Colors.black).copyWith(fontSize: 24.sp,fontWeight: FontWeight.bold),),
                              16.verticalSpace,
                              SizedBox(
                                height: 100.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.forecastday.hour.length,
                                  itemBuilder: (context, index) =>
                                      ForecastHourItem(
                                    hour: controller.forecastday.hour[index],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : WeatherShimmer(),
          ),
        ),
      ),
    );
  }
}
