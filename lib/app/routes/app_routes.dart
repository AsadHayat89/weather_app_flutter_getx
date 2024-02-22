part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const WELCOME = _Paths.WELCOME;
  static const HOME = _Paths.HOME;
  static const WEATHER = _Paths.WEATHER;
  static const MAP = _Paths.MAP;
  static const GALLERY = _Paths.GALLERY;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const WELCOME = '/welcome';
  static const HOME = '/home';
  static const WEATHER = '/weather';
  static const MAP = '/map';
  static const GALLERY = '/gallery';
}
