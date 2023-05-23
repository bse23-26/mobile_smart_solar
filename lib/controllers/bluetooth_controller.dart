import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_solar/storage/storage.dart';

class BluetoothController extends Cubit<String>{
  BluetoothDevice? _server;
  BluetoothConnection? _connection;
  bool isConnecting = true;
  bool isDisconnecting = false;
  final String _serverDetailsKey = 'btServer';
  final List<Message> _messages = List<Message>.empty(growable: true);
  String _messageBuffer = '';
  static const clientID = 0;

  BluetoothController(super.initialState){
    Storage.instance.read(_serverDetailsKey).then((readData){
      if(readData.dataType==StorageDataType.json){
        _server = BluetoothDevice.fromMap(readData.data as Map);
      }
    });
  }

  bool get isConnected => (_connection?.isConnected ?? false);

  connect(BluetoothDevice server){
    _server = server;
    Storage.instance.write(_serverDetailsKey, _server!.toMap());
    BluetoothConnection.toAddress(_server!.address).then((connection) {
      log('Connected to the device');
      _connection = connection;

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
      });
    }).catchError((error) {
      log('Cannot connect, exception occurred');
      log(error);
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
    emit(_messages.last.text);
  }

  void sendMessage(String text) async {
    text = text.trim();

    if (text.isNotEmpty) {
      try {
        _connection!.output.add(Uint8List.fromList(utf8.encode("$text\r\n")));
        await _connection!.output.allSent;
        _messages.add(Message(clientID, text));
      } catch (e) {
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