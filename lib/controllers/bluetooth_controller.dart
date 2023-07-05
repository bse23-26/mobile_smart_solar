import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_solar/controllers/configuration_controller.dart';
import 'package:smart_solar/storage/storage.dart';

enum BluetoothEmitType{
  connectionState,
  message
}

class BluetoothController extends Cubit<BluetoothData?>{
  BluetoothDevice? _server;
  BluetoothConnection? _connection;
  bool isConnecting = false;
  bool isDisconnecting = false;
  final String _serverDetailsKey = 'btServer';
  final List<Message> _messages = List<Message>.empty(growable: true);
  String _messageBuffer = '';
  static const clientID = 0;
  static BluetoothController? inst;

  BluetoothController(super.initialState){
    inst ??= this;
    Storage.instance.containsKeys(_serverDetailsKey).then((hasKey) {
      if(hasKey) {
        Storage.instance.read(_serverDetailsKey).then((readData) {
          if (readData.dataType == StorageDataType.json) {
            _server = BluetoothDevice.fromMap(readData.data as Map);
          }
        });
      }
    });
  }

  bool get isConnected => (_connection?.isConnected ?? false);

  connectSavedDevice(){
    if(isConnected || isConnecting) return;
    if(_server != null) {
      connect(_server!);
    }
  }

  connect(BluetoothDevice server){
    isConnecting = true;
    _server = server;
    Storage.instance.write(_serverDetailsKey, _server!.toMap());

    BluetoothConnection.toAddress(_server!.address).then((connection) {
      log('Connected to the device');
      _connection = connection;

      emit(BluetoothData(BluetoothEmitType.connectionState, 'Yes'));

      sendMessage('200');

      _connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          log('Disconnecting locally!');
        } else {
          log('Disconnected remotely!');
        }
        emit(BluetoothData(BluetoothEmitType.connectionState, 'No'));

      });
      isConnecting = false;
    }).catchError((error) {
      log('Cannot connect, exception occurred');
      log(error.toString());
      emit(BluetoothData(BluetoothEmitType.connectionState, 'No'));
      isConnecting = false;
    });
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
        _messages.add(
          Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
          0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
    if(_messages.last.whom == 0){
      return;
    }
    String msg = _messages.last.text;

    try {
      Map<String, dynamic> map = jsonDecode(msg);
      sendMessage('000');
      log('should send');
      log(msg);
      if (map['type'] == 'configurations') {
        ConfigurationController.inst?.updateFromDevice(map['data']);
      } else if(map['type'] == 'voltage'){
        ConfigurationController.inst?.updateVoltageFromDevice(map['data']);
      }
      else {
        emit(BluetoothData(BluetoothEmitType.message, msg));
      }
    }
    catch(error, stackTrace){
      log(error.toString());
      log(stackTrace.toString());
    }
  }

  void sendMessage(String text) async {
    text = text.trim();

    if (text.isNotEmpty) {
      try {
        _connection!.output.add(Uint8List.fromList(utf8.encode("$text\r\n")));
        await _connection!.output.allSent;
        _messages.add(Message(clientID, text));
      } catch (e, stackTrace) {
        log(stackTrace.toString());
        // Ignore error, but notify state
      }
    }
  }

}

class Message {
  int whom;
  String text;

  Message(this.whom, this.text);
}

class BluetoothData{
  BluetoothEmitType emitType;
  String data;

  BluetoothData(this.emitType, this.data);
}