import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_styles.dart';
import '../size_config.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
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
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), (){
      setSystemUI();
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage('assets/bluetooth_eco.png'),
                width: SizeConfig.screenWidth,
              ),
              Text("Smart solar relies on bluetooth", style: fontMedium.copyWith(color: black, fontSize: SizeConfig.blockSizeHorizontal!*6)),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              Text("Enabling your bluetooth connection is important because it helps us get the closest smart solar power device.",
                style: fontRegular.copyWith(color: darkGrey, fontSize: SizeConfig.blockSizeHorizontal!*5), textAlign: TextAlign.center,),
            ],
          )
      ),
    );
  }
}