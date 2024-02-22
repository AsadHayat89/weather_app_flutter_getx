import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/app/modules/home/views/widgets/shimmer_widget.dart';

class WeatherShimmer extends StatelessWidget {
  const WeatherShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget.circular(
                  width: 50.w,
                  height: 50.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.verticalSpace,
                    ShimmerWidget.rectangular(
                      width: 157.w,
                      height: 54.h,
                    ),
                  ],
                ),
              ],
            ),
            24.verticalSpace,
            ShimmerWidget.rectangular(
              height: 294.h,
              width: 220.w,
            ),
            40.verticalSpace,
            Row(
              children: [
                ShimmerWidget.rectangular(
                  width: 170.w,
                  height: 24.h,
                ),
              ],
            ),
            16.verticalSpace,
            Row(
              children: [
                ShimmerWidget.rectangular(height: 144.h,width: 80.w,),
                16.horizontalSpace,
                ShimmerWidget.rectangular(height: 144.h,width: 80.w,),
                16.horizontalSpace,
                ShimmerWidget.rectangular(height: 144.h,width: 80.w,),



              ],
            )
          ],
        ),
      ),
    );
  }
}
