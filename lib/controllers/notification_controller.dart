import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_solar/models/notification.dart';
import '../storage/storage.dart';

class NotificationController extends Cubit<int>{
  static const String _storageKey = 'notifications';
  static NotificationController? inst;

  NotificationController(super.initialState){
    inst ??= this;
    Storage.instance.containsKeys(_storageKey).then((hasKey) {
      if(hasKey) {
        Storage.instance.read(_storageKey).then((readData) {
          Map<String, dynamic> dt = readData.data;
          List<Map<String, dynamic>> notifications = [];

          dt.forEach((key, value) {
            notifications.add(jsonDecode(value) as Map<String, dynamic>);
          });
          // List<Map<String, dynamic>> notifications = readData.data.entries.toList(); //error
          NotificationModel.allFromList(notifications);
          emitData();
        });
      }else{
        saveToStorage();
        emitData();
      }
    });
  }

  emitData(){
    emit(NotificationModel.all.length);
  }

  static void saveToStorage() {
    Map<String, dynamic> map = {};
    for(int i=0; i<NotificationModel.all.length; i++){
      map[i.toString()] = jsonEncode(NotificationModel.all[i]);
    }

    Storage.instance.write(_storageKey, map);
  }

  static void addNotification(String subject, String description, String time){
    NotificationModel(subject, description, time);
    saveToStorage();
    inst?.emitData();
  }
}