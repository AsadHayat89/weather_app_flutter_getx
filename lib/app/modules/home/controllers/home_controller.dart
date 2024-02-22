import 'package:get/get.dart';
import 'package:weather_app/app/data/local/enum/preference_enum.dart';
import 'package:weather_app/app/routes/app_pages.dart';
import 'dart:convert' as converter;
import '../../../../utils/constants.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../data/models/weather_model.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';
import '../../../services/location_service.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  // get the current language code
  // hold current weather data
  late WeatherModel currentWeather;

  RxBool apiCalled=false.obs;

  // hold the weather arround the world
  List<WeatherModel> weatherArroundTheWorld = [];

  // for update
  final dotIndicatorsId = 'DotIndicators';
  final themeId = 'Theme';

  // api call status
  ApiCallStatus apiCallStatus = ApiCallStatus.loading;

  // for app theme

  // for weather slider and dot indicator
  var activeIndex = 1;

  @override
  void onInit() async {
    getUserLocation();
    super.onInit();
  }

  /// get the user location
  getUserLocation() async {
    var locationData = await LocationService().getUserLocation();
    if (locationData != null) {
      await getCurrentWeather('${locationData.latitude},${locationData.longitude}');
      Map<String, List<dynamic>> data=await getData();
      getWeatherArroundTheWorld(data);
    }
  }
  
  /// get home screem data (sliders, brands, and cars)
  getCurrentWeather(String location) async {
    await BaseClient.safeApiCall(
      Constants.currentWeatherApiUrl,
      RequestType.get,
      queryParameters: {
        Constants.key: Constants.mApiKey,
        Constants.q: location,
       },
      onSuccess: (response) async {
        currentWeather = WeatherModel.fromJson(response.data);
       // await getWeatherArroundTheWorld();
        apiCalled.value=true;
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        apiCalled.value=false;
        update();
      },
    );
  }

  moveToMap() async{

    await Get.toNamed(Routes.MAP);
    Map<String, List<dynamic>> data=await getData();
    getWeatherArroundTheWorld(data);

  }

  Future<Map<String, List<dynamic>>> getData() async {
    String? data = MySharedPrefClass.getValue(PreferenceEnum.LOACTION.name);
    Map<String, List<dynamic>> locationData = {};
    if (data == null || data.isEmpty) {
      return locationData;
    } else {
      String jsonString = data;
      if (jsonString != null) {
        Map<String, dynamic> jsonMap = converter.jsonDecode(jsonString);
        Map<String, List<dynamic>> resultMap = {};
        jsonMap.forEach((key, value) {
          List<dynamic> list =
          (value as List).map((e) => e.toDouble()).toList();
          resultMap[key] = list;
        });
        return resultMap;
      } else {
        return {};
      }
    }
  }

  /// get weather arround the world
  getWeatherArroundTheWorld(Map<String,List<dynamic>> data) async {
    weatherArroundTheWorld.clear();
    final cities = ['London', 'Cairo', 'Alaska'];
    for(int i=0;i<data.length;i++){
      BaseClient.safeApiCall(
        Constants.currentWeatherApiUrl,
        RequestType.get,
        queryParameters: {
          Constants.key: Constants.mApiKey,
          Constants.q: ('${data[1]},${data[0]}'),
        },
        onSuccess: (response) {
          weatherArroundTheWorld.add(WeatherModel.fromJson(response.data));
          update();
        },
        onError: (error) => BaseClient.handleApiError(error),
      );
    }
  }

  /// when the user slide the weather card
  onCardSlided(index, reason) {
    activeIndex = index;
    update([dotIndicatorsId]);
  }



}
