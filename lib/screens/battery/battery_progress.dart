import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:smart_solar/size_config.dart';

class BatteryProgress extends StatelessWidget {
  final double fullVoltage;
  final double availableVoltage;
  final double remainingTime;// in mins

  const BatteryProgress({
    Key? key,
    required this.fullVoltage,
    required this.availableVoltage,
    required this.remainingTime,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double availabilityRatio = availableVoltage/fullVoltage;
    int remainingMinutes = (remainingTime.toInt()%60);
    int remainingHours = (remainingTime.toInt()-remainingMinutes)~/60;
    return Column(
      children: [
        SizedBox(
            height: 200, width:200,
            child:LiquidCircularProgressIndicator(
                value: availabilityRatio, // Defaults to 0.5.
                valueColor: AlwaysStoppedAnimation(Colors.lightBlue[200]!), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                borderColor: Colors.blueAccent,
                borderWidth: 2.0,
                direction: Axis.vertical,
                // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${(availabilityRatio*100).toInt()}%", style: const TextStyle(fontSize: 20),),
                        const Text(" charged"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("$remainingHours", style: const TextStyle(fontSize: 20),),
                        const Text(" hrs "),
                        Text("$remainingMinutes", style: const TextStyle(fontSize: 20),),
                        const Text(" mins"),
                      ],
                    ),
                    const Text("Remaining"),
                  ],
                )
            )
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical!,
        ),
        Text('Battery full voltage: ${fullVoltage}V', style: const TextStyle(fontSize: 18)),
        SizedBox(
          height: SizeConfig.blockSizeVertical!,
        ),
        Text('Available voltage: ${availableVoltage}V', style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}
