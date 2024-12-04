abstract class Routes {
  Routes._();
  static const home = _Paths.home;
  static const initial = _Paths.initialRoute;

  static const themes = _Paths.themes;
}

abstract class _Paths {
  _Paths._();

  static const initialRoute = '/';

  static const home = '/home';
  static const themes = '/themes';
}
