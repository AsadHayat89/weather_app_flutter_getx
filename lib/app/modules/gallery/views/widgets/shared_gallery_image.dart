import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/modules/gallery/controllers/gallery_controller.dart';

class SharedImagePage extends GetView<GalleryController> {
  const SharedImagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: controller.sharedImage.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Image.file(
              controller.sharedImage[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
