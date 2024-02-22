import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/config/font_style.dart';

import '../../../../../utils/extensions.dart';
import '../../../../../config/strings_enum.dart';
import '../../../../components/custom_cached_image.dart';
import '../../../../data/models/weather_details_model.dart';

class WeatherDetailsCard extends StatelessWidget {
  final WeatherDetailsModel weatherDetails;
  final Forecastday forecastDay;
  final int index;
  const WeatherDetailsCard({
    super.key,
    required this.weatherDetails,
    required this.forecastDay,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        children: [
          30.verticalSpace,
          // CustomCachedImage(
          //   imageUrl: forecastDay.day.condition.icon.toHighRes().addHttpPrefix(),
          //   fit: BoxFit.cover,
          //   width: 150.w,
          //   height: 150.h,
          //   color: Colors.white,
          // ),
          30.verticalSpace,
          Text(
            '${weatherDetails.forecast.forecastday[index].date.convertToDay()}',
            style: FontClass.displayMedium(Colors.white),
            textAlign: TextAlign.center,
          ),
          30.verticalSpace,
          Text(
            '${weatherDetails.location.name.toRightCity()}, ${weatherDetails.location.country.toRightCountry()}',
            style: FontClass.displayMedium(Colors.white),
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          Text(
            '${forecastDay.day.maxtempC.toInt()}${Strings.celsius.tr}',
            style: FontClass.displayMedium(Colors.white).copyWith(fontSize: 64.sp),
          ),
          16.verticalSpace,
          Text(
            forecastDay.day.condition.text,
            style: FontClass.displayMedium(Colors.white).copyWith(fontSize: 24.sp,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}