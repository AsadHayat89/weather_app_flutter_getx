import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_app/app/components/custom_snackbar.dart';

class CropImage extends StatefulWidget {
  final Uint8List imageData;
  final String imageName;

  CropImage({Key? key, required this.imageData,required this.imageName}) : super(key: key);

  @override
  State<CropImage> createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {
  final _controller = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Crop(
              image: widget.imageData,
              controller: _controller,
              onCropped: (image) {
                saveGalleryImage(image,widget.imageName);
              },
              aspectRatio: 4 / 3,
              baseColor: Colors.white,
              maskColor: Colors.white.withAlpha(100),
              progressIndicator: const CircularProgressIndicator(),
              radius: 20,
              onMoved: (newRect) {
                // do something with current crop rect.
              },
              onStatusChanged: (status) {
                // do something with current CropStatus
              },
              willUpdateScale: (newScale) {
                // if returning false, scaling will be canceled
                return newScale < 5;
              },
              cornerDotBuilder: (size, edgeAlignment) =>
                  const DotControl(color: Colors.blue),
              clipBehavior: Clip.none,
              interactive: true,
            
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(

                onPressed: () {
                  _controller.crop();
                 },
                child: Text('Save'),
              ),
              SizedBox(
                width: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
            ],//
          )
        ],
      ),
    );
  }

  saveGalleryImage(Uint8List imageBytes,String image) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String folderPath = '${directory.path}/images';
    Directory(folderPath).createSync(recursive: true);
    String uniqueFileName = '${image}';
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
}
