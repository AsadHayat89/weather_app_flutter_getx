
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/app/components/long_button.dart';

import '../controllers/mapController.dart';

class MapView extends GetView<mapController>  {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{

        Get.back();
        return false;
      },
      child: Scaffold(
        //backgroundColor: colors.accentPrimaryDark,
        body: SafeArea(
          child: Stack(
            children: [
              Obx(
                    () => GoogleMap(
                  mapType: MapType.normal,
                  markers: controller.markers,
                  initialCameraPosition: controller.cameraPosition.value,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (mapController) {
                    controller.initMapController(mapController);
                    mapController.animateCamera(
                      controller.cameraUpdate.value,
                    );
                  },
                  // onCameraMove: (position) {
                  //   controller.setCameraPosition(position);
                  // },
                  onTap: (position) {
                    if (controller.permissions == LocationPermission.always ||
                        controller.permissions == LocationPermission.whileInUse) {
                      controller.markers.value.clear();
                      controller.markers.value.add(
                        Marker(
                          markerId: MarkerId(
                              (position.latitude + position.longitude).toString()),
                          icon: controller!.icon!,
                          position: LatLng(
                            position.latitude,
                            position.longitude,
                          ),
                          // infoWindow: InfoWindow(
                          //   title:
                          //   controller.locationController.value.text.toString(),
                          // ),
                        ),
                      );
                      controller.setGeoAddress(
                        lat: position.latitude,
                        lng: position.longitude,
                      );
                      controller.cameraPosition.value = CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 20,
                      );


                    } else {

                    }
                  },
                  onCameraIdle: () {
                    Future.delayed(
                      Duration.zero,
                          () {
                        controller.setGeoAddress(
                          lat: controller.cameraPosition.value.target.latitude,
                          lng: controller.cameraPosition.value.target.longitude,
                        );
                      },
                    );
                  },
                ),
              ),

              Positioned(
                bottom: 80,
                right: 20,
                child: InkWell(
                  onTap: () async {
                    if (controller.permissions == LocationPermission.always ||
                        controller.permissions == LocationPermission.whileInUse) {
                      await controller.getCurrentLocation();
                    } else {

                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Center(
                      child: Icon(
                        Icons.my_location,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: Column(
                  children: [
                    Obx(
                          () => LongButton(
                        text: 'Confirm',
                        enable: true,
                        onPressed: (){
                          controller.saveData();
                        },
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
