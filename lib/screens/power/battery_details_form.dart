import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smart_solar/app_styles.dart';
import 'package:smart_solar/controllers/configuration_controller.dart';
import 'package:smart_solar/models/power.dart';


class BatteryDetailsForm extends StatefulWidget {

  const BatteryDetailsForm({super.key, required this.details});

  final Map<String, dynamic> details;

  @override
  State<BatteryDetailsForm> createState() => _BatteryDetailsFormState();
}

class _BatteryDetailsFormState extends State<BatteryDetailsForm> {

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _minVoltage = TextEditingController();
  final TextEditingController _maxVoltage = TextEditingController();
  final TextEditingController _nominalVoltage = TextEditingController();
  final TextEditingController _rating = TextEditingController();
  final TextEditingController _unit = TextEditingController();

  late List<Widget> children;
  Widget sizedBox = SizedBox(height: paddingHorizontal*1.2);

  @override
  void initState() {
    super.initState();
    if(widget.details['minVoltage'] != BatteryDataDefaults.minVoltage.toString()){
      _minVoltage.text = widget.details['minVoltage'];
      _maxVoltage.text = widget.details['maxVoltage'];
      _nominalVoltage.text = widget.details['nominalVoltage'];
      _rating.text = widget.details['rating'];
      _unit.text = 'Ah';
      //add units
    }

    children = [
      sizedBox, makeInput(_minVoltage, 'Min Voltage', 'minimum Voltage'),
      sizedBox, makeInput(_maxVoltage, 'Max Voltage', 'maximum Voltage'),
      sizedBox, makeInput(_nominalVoltage, 'Nominal Voltage', 'nominal Voltage'),
      sizedBox
    ];
  }

  Widget makeInput(TextEditingController controller, String hint, String validationText){
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(fontSize: 22),
          hintStyle: const TextStyle(fontSize: 20),
        border: const OutlineInputBorder(),
        hintText: hint,
        isDense: true,
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $validationText';
        }
        double num = double.parse(value);
        if(num.isNaN){
          return 'Decimal required e.g 2.5';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        sizedBox,
        const Text('Edit Battery Details', style: TextStyle(fontSize: 18),),
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [...children,
              Wrap(
                children: [
                  SizedBox(
                    width: 200,
                    height: 56,
                    child: TextFormField(
                    controller: _rating,
                    keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only()
                      ),
                      hintText: 'Rating',
                      labelText: 'Rating',
                      labelStyle: TextStyle(fontSize: 22),
                      hintStyle: TextStyle(fontSize: 20)
                      // isDense: true,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Rating';
                      }
                      double num = double.parse(value);
                      if(num.isNaN){
                        return 'Decimal required e.g 2.5';
                      }
                      return null;
                    },
                  ),
                  ),
                SizedBox(
                height: 56,
                  child: DropdownMenu<String>(
                    initialSelection: 'Ah',
                    inputDecorationTheme: const InputDecorationTheme(
                      contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(),
                      ),
                    ),
                    controller: _unit,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 'Ah', label: 'Ah'),
                      DropdownMenuEntry(value: 'mAh', label: 'mAh'),
                      DropdownMenuEntry(value: 'Wh', label: 'Wh'),
                      DropdownMenuEntry(value: 'mWh', label: 'mWh'),
                    ],
                  ),
                )
                ],
              ),
            ],
          ),
        ),
        sizedBox,
        Center(
          child: ElevatedButton(
              onPressed: (){
                if (_form.currentState!.validate()) {
                  Map<String, dynamic> map = {
                    'minVoltage': double.parse(_minVoltage.text),
                    'maxVoltage': double.parse(_maxVoltage.text),
                    'nominalVoltage': double.parse(_nominalVoltage.text),
                    'rating': double.parse(_rating.text),
                    'ratingUnits': _unit.text
                  };
                  ConfigurationController.inst?.updateBatteryConfigFromInput(map);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
          ),
        ),
      ],
    );
  }
}

