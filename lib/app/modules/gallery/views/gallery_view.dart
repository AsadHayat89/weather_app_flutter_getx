import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/modules/gallery/views/widgets/gallery_images.dart';
import 'package:weather_app/app/modules/gallery/views/widgets/shared_gallery_image.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: (){
              Get.back();
            },
          ),
          title: Text('Gallery Photos'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Gallery'),
              Tab(text: 'Shared Images'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            GalleryImages(),
            SharedImagePage(),
          ],
        ),
      ),
    );
  }
}
