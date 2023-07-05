import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smart_solar/controllers/configuration_controller.dart';

class PowerlineTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String lineNum;
  final bool active;

  const PowerlineTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.active, required this.lineNum
  }) : super(key: key);

  // static builder(Map<String, dynamic> properties){
  //
  //   return PowerlineTile(
  //       title: properties['alias'] ?? properties['name'],
  //       subtitle: (properties['alias'] == null)?"":properties['name'],
  //       active: properties['state'] == 1, lineNum: properties['name'],
  //   );
  // }

  @override
  State<PowerlineTile> createState() => _PowerlineTileState();
}

class _PowerlineTileState extends State<PowerlineTile> {
  @override
  Widget build(BuildContext context) {
    TextStyle stateStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
    return SwitchListTile(
      value: widget.active, onChanged: (bool value) {
      ConfigurationController.inst?.updatePowerlineStateFromInput({widget.lineNum: value?1:0});
      },
      secondary: widget.active?
      Text("on", style: stateStyle.copyWith(color: Colors.green)):
      Text("off", style: stateStyle.copyWith(color: Colors.red)),
      title:Text(widget.title, style: const TextStyle(fontSize: 20),),
      subtitle: widget.subtitle.isEmpty?null:Text(widget.subtitle, style: const TextStyle(fontSize: 16),),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
// subtitle.isEmpty?null: