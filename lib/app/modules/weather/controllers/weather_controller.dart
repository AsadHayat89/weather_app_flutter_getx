import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:weather_app/app/components/custom_snackbar.dart';

import '../../../../config/strings_enum.dart';
import '../../../../utils/constants.dart';
import '../../../data/models/weather_details_model.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';

class WeatherController extends GetxController {
  static WeatherController get instance => Get.find();

  // get the current language code

  // hold the weather details & forecast day
  late WeatherDetailsModel weatherDetails;
  late Forecastday forecastday;

  // for update
  final dotIndicatorsId = 'DotIndicators';

  final screenshotController = ScreenshotController();

  // for weather forecast
  final days = 7;

  //var selectedDay = 'Today';
  var selectedDay = Strings.today.tr;

  RxBool isApiCalled = false.obs;

  // api call status
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  // for weather card slider
  late PageController pageController;

  // for weather slider and dot indicator
  var currentPage = 0;

  @override
  void onInit() async {
    pageController = PageController(
      initialPage: currentPage,
      viewportFraction: 0.8,
    );
    super.onInit();
  }

  @override
  void onReady() {
    getWeatherDetails();
    super.onReady();
  }

  void takeScreenshot() async {
    final imageFile = await screenshotController.capture();
    screenshotController
        .capture(delay: Duration(milliseconds: 10))
        .then((capturedImage) async {
      ShowCapturedWidget(Get.context!, capturedImage!);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.memory(capturedImage!),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    saveGalleryImage(capturedImage); // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
                SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  saveGalleryImage(Uint8List imageBytes) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String folderPath = '${directory.path}/images';
    Directory(folderPath).createSync(recursive: true);
    String uniqueFileName = 'image_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecondsSinceEpoch}_${DateTime.now().microsecond}.jpg';
    String filePath = '${folderPath}/${uniqueFileName}';
    // Save the file
    await File(filePath).writeAsBytes(imageBytes).then((value) => {
          if (value.path.isNotEmpty)
            {
              CustomSnackBar.showCustomSnackBar(
                  title: "success", message: "Image Saved")
            }
        });
  }

  /// get weather details
  getWeatherDetails() async {
    await BaseClient.safeApiCall(
      Constants.forecastWeatherApiUrl,
      RequestType.get,
      queryParameters: {
        Constants.key: Constants.mApiKey,
        Constants.q: Get.arguments,
        Constants.days: days,
      },
      onSuccess: (response) {
        weatherDetails = WeatherDetailsModel.fromJson(response.data);
        forecastday = weatherDetails.forecast.forecastday[0];
        apiCallStatus = ApiCallStatus.success;
        isApiCalled.value = true;
        update();
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        isApiCalled.value = false;
        update();
      },
    );
  }

  /// when the user slide the weather card
  onCardSlided(int index) {
    forecastday = weatherDetails.forecast.forecastday[index];
    //selectedDay = forecastday.date.convertToDay();
    currentPage = index;
    update();
  }
}
