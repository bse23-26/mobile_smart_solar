import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'routes.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  void setSystemUI(){
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    setSystemUI();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartSolar',
      routes: routes,
      initialRoute: '/',
    );
  }
}

