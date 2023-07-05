import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_solar/controllers/bluetooth_controller.dart';
import 'package:smart_solar/controllers/configuration_controller.dart';
import 'package:smart_solar/controllers/notification_controller.dart';
import 'package:smart_solar/requests/firebase_api.dart';
import 'package:smart_solar/routes/route_names.dart';
import 'routes/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi.init();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark
      ));
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BluetoothController>(create: (_)=>BluetoothController(null)),
        BlocProvider<ConfigurationController>(create: (_)=>ConfigurationController({})),
        BlocProvider<NotificationController>(create: (_)=>NotificationController(0))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartSolar',
        routes: routes,
        initialRoute: Routes.root,
        navigatorKey: navigatorKey,
      ),
    );
  }
}




