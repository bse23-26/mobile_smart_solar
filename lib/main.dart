import 'package:flutter/material.dart';
import 'package:smart_solar/cubits/bluetooth_cubit.dart';
import 'package:smart_solar/routes/route_names.dart';
import 'routes/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BluetoothCubit>(create: (_)=>BluetoothCubit("bloc_data"))
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




