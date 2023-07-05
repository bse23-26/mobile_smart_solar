import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_solar/app_styles.dart';
import 'package:smart_solar/controllers/configuration_controller.dart';
import 'package:smart_solar/controllers/notification_controller.dart';
import 'package:smart_solar/size_config.dart';
import 'package:smart_solar/routes/route_names.dart';
import 'package:smart_solar/storage/storage.dart';

import '../controllers/bluetooth_controller.dart';
import '../models/user.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double progressValue = 0;
  Timer? timer;

  String initialiseUser(Map<String, dynamic> userData){
    User.fromMap(userData);
    return Routes.home;
  }

  @override
  void initState() {
    context.read<BluetoothController>();
    context.read<ConfigurationController>();
    context.read<NotificationController>();

    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (Timer t) => setState(() {
      if(progressValue<1) {
        progressValue += 0.25;
      }
      else{
        timer?.cancel();
        Storage.instance.read('user').then((storageData){
          Navigator.pushReplacementNamed(context, (storageData.dataType == StorageDataType.undefined)?Routes.auth:initialiseUser(storageData.data as Map<String, dynamic>));
        });
      }
    }));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal*5, vertical: paddingHorizontal*9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: SizeConfig.blockSizeVertical! * 10),
              Image(
                image: const AssetImage('assets/logo.png'),
                width: SizeConfig.screenWidth!*0.6,
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              const Text('SmartSolar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: LinearProgressIndicator(
                  value: progressValue,
                  semanticsLabel: 'Linear progress indicator',
                  backgroundColor: const Color(0xffD3D3D3),
                  color: Colors.blue,
                  minHeight: 8,
                ),
              ),
            ],
          )
      ),
    );
  }
}


