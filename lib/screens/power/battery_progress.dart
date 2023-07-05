import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:smart_solar/models/power.dart';

class BatteryProgress extends StatefulWidget {
  final String maxVoltage;
  final String minVoltage;
  final String nominalVoltage;
  final String availableVoltage;
  final String rating;
  final String remHours;
  final String remMinutes;
  final double availabilityRatio;

  BatteryProgress({super.key,
    required this.maxVoltage, required this.minVoltage, required this.nominalVoltage, required this.availableVoltage, required this.remHours, required this.remMinutes, required this.availabilityRatio, required this.rating,
  }){
    if(minVoltage == BatteryDataDefaults.minVoltage.toString()){
      cminVoltage = "Unknown";
      cmaxVoltage = "Unknown";
      cnominalVoltage = "Unknown";
      cavailableVoltage = "Unknown";
      crating = "Unknown";
    }else{
      cminVoltage = minVoltage;
      cmaxVoltage = maxVoltage;
      cnominalVoltage = nominalVoltage;
      cavailableVoltage = availableVoltage;
      crating = rating;
    }
  }

  late final String cmaxVoltage;
  late final String cminVoltage;
  late final String cnominalVoltage;
  late final String cavailableVoltage;
  late final String crating;

  @override
  State<BatteryProgress> createState() => _BatteryProgressState();
}

class _BatteryProgressState extends State<BatteryProgress> {
  @override
  Widget build(BuildContext context) {
    // double availabilityRatio = availableVoltage/fullVoltage;
    // int remainingMinutes = (remainingTime.toInt()%60);
    // int remainingHours = (remainingTime.toInt()-remainingMinutes)~/60;

    return Column(
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: LiquidCircularProgressIndicator(
              value: widget.availabilityRatio, // Defaults to 0.5.
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
                      Text("${(widget.availabilityRatio*100).toInt()}%", style: const TextStyle(fontSize: 20),),
                      const Text(" charged"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(widget.remHours, style: const TextStyle(fontSize: 20),),
                      const Text(" hrs "),
                      Text(widget.remMinutes, style: const TextStyle(fontSize: 20),),
                      const Text(" mins"),
                    ],
                  ),
                  const Text("Remaining"),
                ],
              )
          ),
        ),
        Card(
          elevation: 2,

          child: Column(
            children: [
              DetailTile(label: 'Maximum voltage', detail: widget.cmaxVoltage),
              DetailTile(label: 'Minimum voltage', detail: widget.cminVoltage),
              DetailTile(label: 'Nominal voltage', detail: widget.cnominalVoltage),
              DetailTile(label: 'Available voltage', detail: widget.cavailableVoltage),
              DetailTile(label: 'Rating', detail: widget.crating),
            ],
          ),
        )
      ],
    );
  }
}

class DetailTile extends StatelessWidget {
  final String label;
  final String detail;
  const DetailTile({super.key, required this.label, required this.detail});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(label, style: const TextStyle(fontSize: 18)),
      trailing: Text(detail, style: const TextStyle(fontSize: 18, color: Colors.indigo)),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      dense: true,
    );
  }
}

