import 'package:shared_preferences/shared_preferences.dart';


class MySharedPrefClass {
  // prevent making instance
  MySharedPrefClass._();

  // get storage
  static late SharedPreferences _sharedPreferences;


  /// init get storage services
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  /// set Value
  static Future<void> setValue(String key,String value) =>
      _sharedPreferences.setString(key, value);

  ///get Values
  static String? getValue(String key) {
    return _sharedPreferences.getString(key);
  }

    
  /// clear all data from shared pref
  static Future<void> clear() async => await _sharedPreferences.clear();

}