import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_solar/controllers/bluetooth_controller.dart';
import 'package:smart_solar/routes/route_names.dart';
import 'routes/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white
  ));
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BluetoothController>(create: (_)=>BluetoothController(""))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartSolar',
        routes: routes,
        initialRoute: Routes.root,
      ),
    );
  }
}




