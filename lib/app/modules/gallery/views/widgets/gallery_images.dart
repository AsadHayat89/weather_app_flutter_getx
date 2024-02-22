import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/modules/gallery/controllers/gallery_controller.dart';

class GalleryImages extends GetView<GalleryController> {
  const GalleryImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: controller.savedImage.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onLongPress: (){
              controller.showShareDialog(context,controller.savedImage[index]);
            },
            onTap: () {
              // Handle image tap (if needed)
              controller.moveToCroppedScreen(
                  controller.savedImage[index].readAsBytesSync(),
                  controller.savedImage[index].path.split("/").last);
            },
            child: Image.file(
              controller.savedImage[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
