import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class BluetoothCubit extends Cubit<dynamic>{
  BluetoothCubit(super.initialState){
    String initStr = state.toString();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(initStr+timer.tick.toString());
    });
  }
}