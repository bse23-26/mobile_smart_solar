import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_solar/controllers/configuration_controller.dart';
import 'package:smart_solar/screens/power/battery_details_form.dart';
import 'package:smart_solar/screens/power/battery_progress.dart';
import 'package:smart_solar/app_styles.dart';
import 'package:smart_solar/screens/power/powerline_form.dart';
import 'package:smart_solar/size_config.dart';
import '../../models/power.dart';
import 'powerline_tile.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({Key? key}) : super(key: key);

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {

  void _showModalBottomSheet(Widget child){
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        // isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (BuildContext context){
          final viewInsets = MediaQuery.of(context).viewInsets;
          return SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.only(bottom: viewInsets.bottom+10, left: 10, right: 10),
              child: child,
            ),
          );
        }
    );
  }

  void _showPowerlineForm(List<dynamic> lines){
    _showModalBottomSheet(PowerlineForm(lines: lines));
  }

  void _showBatteryDetailsForm(Map<String, dynamic> details){
    _showModalBottomSheet(BatteryDetailsForm(details: details));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigurationController, Map<String, dynamic>>(
        builder: (context, data) {
          double remainingTime = ((data['time']??0.0)*60); //convert to minutes
          int remainingMinutes = (remainingTime.toInt()%60);
          int remainingHours = (remainingTime.toInt()-remainingMinutes)~/60;
          List<dynamic> lines = data['powerlines'] ?? [];

          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal*0.5, vertical: paddingHorizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text('Battery Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  trailing: IconButton(
                    onPressed: () {
                      _showBatteryDetailsForm(data);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical!,
                ),
                BatteryProgress(
                  maxVoltage: data['maxVoltage'] ?? "",
                  minVoltage:  data['minVoltage'] ?? BatteryDataDefaults.minVoltage.toString(),
                  nominalVoltage:  data['nominalVoltage'] ?? "",
                  availableVoltage: data['availableVoltage'] ?? "",
                  remHours: remainingHours.toString(),
                  remMinutes: remainingMinutes.toString(),
                  availabilityRatio: 92/100,
                  rating: data['ratingWithUnits'] ?? "",
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical!,
                ),
                ListTile(
                  title: const Text('Powerlines', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  trailing: IconButton(
                      onPressed: () {
                        _showPowerlineForm(lines);
                      },
                      icon: const Icon(Icons.edit)
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: paddingHorizontal*0.1),
                      scrollDirection: Axis.vertical,
                      itemCount: lines.length,
                      itemBuilder: (BuildContext context, int index){
                        var properties = lines[index];

                        return PowerlineTile(
                          title: properties['alias'] ?? properties['name'],
                          subtitle: (properties['alias'] == null)?"":properties['name'],
                          active: properties['state'] == '1', lineNum: properties['name'],
                        );
                      }
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}