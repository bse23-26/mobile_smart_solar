import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_solar/controllers/bluetooth_controller.dart';
import 'package:smart_solar/helpers/helpers.dart';
import 'package:smart_solar/models/power.dart';

import '../storage/storage.dart';

class ConfigurationController extends Cubit<Map<String, dynamic>>{
  static const String _configKey = 'config';
  static const String _devConfigKey = 'devConfig';
  static ConfigurationController? inst;

  ConfigurationController(super.initialState){
    inst ??= this;
    Storage.instance.containsKeys(_configKey).then((hasKey) {
      if(hasKey) {
        Storage.instance.read(_devConfigKey).then((readData) {
          if (readData.dataType == StorageDataType.json) {
            devConfig=readData.data;
          }

          Storage.instance.read(_configKey).then((readData) {
            if (readData.dataType == StorageDataType.json) {
              if((readData.data['powerlines'] as List).isEmpty) {
                List<Map<String, dynamic>> lines = [];
                readData.data['powerlines'] = lines;
              }

              updateFromStorage(readData.data);
              readData.data['percentage'] = Battery.percentage;
              readData.data['ratingWithUnits'] = Battery.ratingWithUnits;
              readData.data['time'] = Battery.time;
              emit(readData.data);
            }
          });
        });
      }else{
        saveToStorage().then((value){
          emit(value);
        });
      }
    });
  }

  // static void update(Map<String, dynamic> configurations){
  //   //set Battery details
  //   Battery.minVoltage = configurations['minVoltage'] as double;
  //   Battery.maxVoltage = configurations['maxVoltage'] as double;
  //   Battery.nominalVoltage = configurations['nominalVoltage'] as double;
  //   Battery.setRating(configurations['rating'] as double, 'Ah');
  // }

  void updateFromStorage(Map<String, dynamic> configurations){
    Battery.initFromMap(configurations);
    Powerline.powerlinesFromMapList(configurations['powerlines']);
  }

  void updateVoltageFromDevice(int voltage){
    const int maxAnalogValue = 1015;
    const int maxVoltage = 25;
    Battery.availableVoltage = toDouble(toDouble((voltage/maxAnalogValue)*maxVoltage).toStringAsFixed(2));
    saveToStorage().then((value){
      emit(value);
    });
  }

  void updateFromDevice(Map<String, dynamic> configurations){
    devConfig = configurations;
    // update(configurations);
    configurations['ratingUnits'] = 'Ah';
    Battery.initFromMap(configurations);

    //set powerline details
    int powerlinesNum = configurations['powerlines'];

    if(Powerline.powerlines.isEmpty){
      for (int i=1; i<=powerlinesNum; i++){
        String key = "powerline$i";
        Powerline(key, configurations[key], null);
      }
    }else{
      Map<String, int> map = {};
      for (int i=1; i<=powerlinesNum; i++){
        String key = "powerline$i";
        map[key] = configurations[key];
      }
      Powerline.updateState(map);
    }
    saveToStorage().then((value){
      emit(value);
    });
  }

  void updateBatteryConfigFromInput(Map<String, dynamic> map){
    devConfig['maxVoltage'] = map['maxVoltage'];
    devConfig['minVoltage'] = map['minVoltage'];
    devConfig['nominalVoltage'] = map['nominalVoltage'];
    Battery.setRating(map['rating'], map['ratingUnits']);
    devConfig['rating'] = toDouble(Battery.rating.toStringAsFixed(3));
    log(devConfig['rating'].toString());
    sendToBluetooth();
  }

  void updatePowerlineStateFromInput(Map<String, int> map){
    devConfig.forEach((key, value) {
      if(map.containsKey(key)){
        devConfig[key] = map[key];
      }
    });
    sendToBluetooth();
  }

  void updatePowerlineAliasFromInput(Map<String, String> map){
    Powerline.updateAlias(map);
    saveToStorage().then((value){
      emit(value);
    });
  }

  static Future<Map<String, dynamic>> saveToStorage() async {
    Map<String, dynamic> map = Battery.toMap();
    map['powerlines'] = Powerline.powerlinesToMapCollection();
    await Storage.instance.write(_configKey, map);
    await Storage.instance.write(_devConfigKey, devConfig);

    map['percentage'] = Battery.percentage;
    map['ratingWithUnits'] = Battery.ratingWithUnits;
    map['time'] = Battery.time;
    return map;
  }

  static sendToBluetooth(){
    BluetoothController.inst?.sendMessage('100${jsonEncode(devConfig)}');
  }
}