import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_solar/screens/battery/battery_progress.dart';
import '../../app_styles.dart';
import '../../size_config.dart';
import 'usage_tile.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({Key? key}) : super(key: key);

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  List<Map<String, dynamic>> tiles = [
    {'title': 'Kitchen', 'subtitle': '521.55 mAh | 3 hr 9 min | 33.36%', 'progressValue': 0.7, 'color': const Color(0xff222150), 'active': true},
    {'title': 'Kitchen', 'subtitle': '521.55 mAh | 3 hr 9 min | 33.36%', 'progressValue': 0.7, 'color': const Color(0xff222150), 'active': true},
    {'title': 'Kitchen', 'subtitle': '521.55 mAh | 3 hr 9 min | 33.36%', 'progressValue': 0.7, 'color': const Color(0xff222150), 'active': true},
    {'title': 'Kitchen', 'subtitle': '521.55 mAh | 3 hr 9 min | 33.36%', 'progressValue': 0.7, 'color': const Color(0xff222150), 'active': true},
    {'title': 'Kitchen', 'subtitle': '521.55 mAh | 3 hr 9 min | 33.36%', 'progressValue': 0.7, 'color': const Color(0xff222150), 'active': true},
    {'title': 'Kitchen', 'subtitle': '521.55 mAh | 3 hr 9 min | 33.36%', 'progressValue': 0.7, 'color': const Color(0xff222150), 'active': true},
    {'title': 'Kitchen', 'subtitle': '521.55 mAh | 3 hr 9 min | 33.36%', 'progressValue': 0.7, 'color': const Color(0xff222150), 'active': true},
  ];

  @override
  void initState() {
    print('why');
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal*0.5, vertical: paddingHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.blockSizeVertical!*4,
              ),
              const Text('Battery Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.blue)),
              SizedBox(
                height: SizeConfig.blockSizeVertical! * 3,
              ),
              const BatteryProgress(fullVoltage: 35, availableVoltage: 15, remainingTime: 380),
              SizedBox(
                height: SizeConfig.blockSizeVertical! * 3,
              ),
              const Text('Usage details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.blue)),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: paddingHorizontal*0.1),
                  scrollDirection: Axis.vertical,
                  itemCount: tiles.length,
                  itemBuilder: (BuildContext context, int index) => UsageTile.builder(tiles[index]),
                ),
              ),
            ],
          ),
        )
    );
  }
}