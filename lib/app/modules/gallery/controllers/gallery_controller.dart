import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:weather_app/app/components/custom_snackbar.dart';
import 'package:weather_app/app/modules/gallery/views/widgets/cropped_image.dart';

class GalleryController extends GetxController {
  late RxList<File> savedImage = <File>[].obs;
  late RxList<File> sharedImage = <File>[].obs;
  @override
  void onInit() async {
    getFilesFromSpecificFolder();
    getSharedFiles();
    super.onInit();
  }

  moveToCroppedScreen(Uint8List image, String imageName) async {
    await Get.to(CropImage(
      imageData: image,
      imageName: imageName,
    ));
    getFilesFromSpecificFolder();

  }

  saveGalleryImage(Uint8List imageBytes,String image) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String folderPath = '${directory.path}/shared';
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

  showShareDialog(BuildContext context,File image){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Share'),
          content: Text('Share your files with other'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _shareFile(image);
                Navigator.of(context).pop();
              },
              child: Text('Share'),
            ),
          ],
        );
      },
    );
  }
   _shareFile(File image) async{
     final result = await Share.shareXFiles([XFile(image.path)], text: 'Shared Image');
     if(result.status == ShareResultStatus.success){
       saveGalleryImage(image.readAsBytesSync(),image.path.split('/').last);
       getFilesFromSpecificFolder();
     }
   }


   getSharedFiles() async{

     Directory directory = await getApplicationDocumentsDirectory();
     String folderPath = '${directory.path}/shared';
     sharedImage.clear();
     try {
       Directory folder = Directory(folderPath);
       if (folder.existsSync()) {
         List<FileSystemEntity> files = folder.listSync();
         for (FileSystemEntity file in files) {
           if (file is File) {
             sharedImage.add(file);
           }
         }
       }
       sharedImage.refresh();
       update();
     } catch (e) {
       print('Error retrieving files: $e');
     }
   }

  getFilesFromSpecificFolder() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String folderPath = '${directory.path}/images';
    savedImage.clear();
    try {
      Directory folder = Directory(folderPath);
      if (folder.existsSync()) {
        List<FileSystemEntity> files = folder.listSync();
        for (FileSystemEntity file in files) {
          if (file is File) {
            savedImage.add(file);
          }
        }
      }
      savedImage.refresh();
      update();
    } catch (e) {
      print('Error retrieving files: $e');
    }
  }
}
