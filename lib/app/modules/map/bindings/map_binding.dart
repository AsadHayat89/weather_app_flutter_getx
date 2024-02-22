import 'package:get/get.dart';
import 'package:weather_app/app/modules/map/controllers/mapController.dart';


class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(mapController());
  }
}
