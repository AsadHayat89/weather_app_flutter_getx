import 'dart:async';
import 'dart:convert' as converter;
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/app/components/custom_snackbar.dart';
import 'package:weather_app/app/data/local/enum/preference_enum.dart';
import 'package:weather_app/app/data/local/my_shared_pref.dart';

class mapController extends GetxController {
  Completer<GoogleMapController> completer = Completer();

  double? lat;

  double? lng;
  Rx<bool> isLoading = false.obs;
  BitmapDescriptor? currentLocationIcon;
  List<geo.Placemark>? geoAddress;
  RxSet<Marker> markers = <Marker>{}.obs;
  GoogleMapController? googleMapController;
  Rx<CameraPosition> cameraPosition = CameraPosition(
    target: LatLng(31.475437248598258, 74.40131359309197),
    zoom: 20,
  ).obs;
  Rx<CameraPosition> currentLocation = CameraPosition(
    target: LatLng(31.475437248598258, 74.40131359309197),
    zoom: 20,
  ).obs;
  BitmapDescriptor? icon;

  Rx<CameraUpdate> cameraUpdate = CameraUpdate.newLatLng(
    LatLng(31.475437248598258, 74.40131359309197),
  ).obs;

  LocationPermission? permissions;

  List<geo.Placemark>? _geoAddress;

  @override
  void onInit() async {
    super.onInit();

    /// Allow And Save Location-Start
    MySharedPrefClass.init();
    await getCurrentLocation();
  }

  void addAndUpdateMarker() {
    markers.value.clear();
    var markerId = '2' +
        cameraPosition.value.target.latitude.toString() +
        cameraPosition.value.target.longitude.toString();
    markers.value.add(
      Marker(
        markerId: MarkerId(markerId),
        icon: icon!,
        position: LatLng(
          cameraPosition.value.target.latitude,
          cameraPosition.value.target.longitude,
        ),
        infoWindow: const InfoWindow(
          title: 'Your Current Location',
        ),
      ),
    );
  }

  void saveData() async {
    Map<String, List<dynamic>> data = await getData();
    data['Location ${data.length + 1}'] = [
      cameraPosition.value.target.longitude,
      cameraPosition.value.target.latitude
    ];
    String jsonString = converter.jsonEncode(data);
    MySharedPrefClass.setValue(PreferenceEnum.LOACTION.name, jsonString);
    CustomSnackBar.showCustomSnackBar(
        title: "success", message: "Location Saved");
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

  static Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    try {
      ByteData data = await rootBundle.load(path);
      Codec codec = await instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: width,
      );
      FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(
        format: ImageByteFormat.png,
      ))!
          .buffer
          .asUint8List();
    } catch (e) {
      print(e);
      Uint8List u = Uint8List(0);
      return u;
    }
  }

  Future<void> getCurrentLocation() async {
    final Uint8List uint8list = await _getBytesFromAsset(
      "assets/images/icon.png",
      150,
    );
    icon = BitmapDescriptor.fromBytes(uint8list);
    permissions = await Geolocator.requestPermission();
    if (permissions == LocationPermission.always ||
        permissions == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition();
      _geoAddress = await geo.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      currentLocation.value = CameraPosition(
        target: LatLng(
          position.latitude,
          position.longitude,
        ),
        zoom: 15,
      );
      setCameraPosition(currentLocation.value);
      googleMapController!.animateCamera(
        cameraUpdate.value,
      );
      setGeoAddress(
        lat: cameraPosition.value.target.latitude,
        lng: cameraPosition.value.target.longitude,
      );
      addAndUpdateMarker();
    }
  }

  void setCameraPosition(CameraPosition position) {
    cameraPosition.value = position;
    cameraUpdate.value = CameraUpdate.newCameraPosition(cameraPosition.value);
  }

  void initMapController(controller) {
    googleMapController = controller;
  }

  Future<void> setGeoAddress({double lat = 0.0, double lng = 0.0}) async {
    geoAddress = await geo.placemarkFromCoordinates(
      lat,
      lng,
    );
    // locationController.value.text =
    //     geoAddress![0].street! + ', ' + geoAddress![0].subLocality!;
  }
}
