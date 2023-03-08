import 'package:flutter/material.dart';
import '../../app_styles.dart';
import '../../size_config.dart';
import 'usage_tile.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({Key? key}) : super(key: key);

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal*0.2, vertical: paddingHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.blockSizeVertical! * 3,
              ),
              Column(
                children: [
                  const UsageTile(title: 'Design files', subtitle: '38.66 GB', progressValue: 0.7, color: Color(0xff222150)),
                  const UsageTile(title: 'Paper files', subtitle: '50.26 GB', progressValue: 0.5, color: Colors.red),
                  UsageTile.builder({'title': 'Design files', 'subtitle': '38.66 GB', 'progressValue': 0.7, 'color': const Color(0xff222150)})
                ],
              )
            ],
          ),
        )
    );
  }
}