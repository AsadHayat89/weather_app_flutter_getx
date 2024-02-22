import 'package:get/get.dart';
import 'package:weather_app/app/modules/gallery/controllers/gallery_controller.dart';


class GalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GalleryController>(
          () => GalleryController(),
    );
  }
}
