import 'package:smart_solar/routes/route_names.dart';
import 'package:smart_solar/screens/fault.dart';
import 'package:smart_solar/screens/home.dart';
import 'package:smart_solar/screens/splash.dart';
import 'package:smart_solar/screens/auth.dart';

var routes = {
  Routes.root: (context) => const Splash(),
  Routes.auth: (context) => const Auth(),
  Routes.home: (context) => const HomePage(),
  Routes.notifications: (context) => const HomePage(pageName: 'notifications'),
  Routes.fault: (context) => const Fault()
};