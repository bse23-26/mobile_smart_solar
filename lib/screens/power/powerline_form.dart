import 'package:flutter/material.dart';
import 'package:smart_solar/app_styles.dart';
import 'package:smart_solar/controllers/configuration_controller.dart';


class PowerlineForm extends StatelessWidget {

  PowerlineForm({super.key, required this.lines}){
    for (int i=0; i<lines.length; i++) {
      _aliasControllers.add(TextEditingController());
      _aliasControllers[i].text = lines[i]['alias'] ?? "";
      _inputs.add(makeInput(i));
    }
  }

  late final List<TextEditingController> _aliasControllers = [];
  late final List<Widget> _inputs = [];
  final List<dynamic> lines;

  Widget makeInput(int index){
    return Column(
      children: [
        SizedBox(height: paddingHorizontal),
        Row(
          children: [
            Text(lines[index]['name'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            SizedBox(width: 200,
              child: TextFormField(
                controller: _aliasControllers[index],
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: lines[index]['name']+' alias',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 2),
        const Text('Rename Powerline', style: TextStyle(fontSize: 20),),
        Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _inputs,
          ),
        ),
        SizedBox(height: paddingHorizontal),
        Center(
          child: ElevatedButton(
              onPressed: (){
                Map<String, String> map = {};
                for (int i=0; i<lines.length; i++) {
                  String text = _aliasControllers[i].text.trim();
                  if(text.isNotEmpty){
                    map[lines[i]['name']] = text;
                  }
                }

                ConfigurationController.inst?.updatePowerlineAliasFromInput(map);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
          ),
        ),
        SizedBox(height: paddingHorizontal),
      ],
    );
  }
}

