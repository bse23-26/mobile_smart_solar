import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smart_solar/controllers/bluetooth_controller.dart';
import 'ChatPage.dart';
import 'SelectBondedDevicePage.dart';

enum AlertType {
  error,
  success,
}

class BluetoothMainScreen extends StatefulWidget {
  const BluetoothMainScreen({super.key});

  @override
  State<BluetoothMainScreen> createState() => _BluetoothMainScreen();
}

class _BluetoothMainScreen extends State<BluetoothMainScreen> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";
  String _connectionState = "No";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  @override
  void initState() {
    super.initState();
    context.read<BluetoothController>().connectSavedDevice();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
        if(!_bluetoothState.isEnabled) {
          _connectionState = 'No';
        }else{
          context.read<BluetoothController>().connectSavedDevice();
        }
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });

    _connectionState = context.read<BluetoothController>().isConnected?'Yes':'No';
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  _snackBarAlert({required String message, AlertType type=AlertType.error}){
    Color color = type==AlertType.error?Colors.red:Colors.green;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: color),
          borderRadius: BorderRadius.circular(24),
        ),
        duration: const Duration(seconds: 1),
        // elevation: 0,
        content: Text(message, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color))
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothController, BluetoothData?>(
        builder: (context, data) {
          if(data?.emitType == BluetoothEmitType.connectionState){
            WidgetsBinding.instance.addPostFrameCallback((_){
              setState(() {
                _connectionState = data!.data;
              });
            });
          }
          return ListView(
            children: <Widget>[
              SwitchListTile(
                title: const Text('Enable Bluetooth'),
                value: _bluetoothState.isEnabled,
                onChanged: (bool value) {
                  // Do the request and update with the true value then
                  future() async {
                    // async lambda seems to not working
                    if (value) {
                      await FlutterBluetoothSerial.instance.requestEnable();
                    } else {
                      await FlutterBluetoothSerial.instance.requestDisable();
                    }
                  }

                  future().then((_) {
                    setState(() {});
                  });
                },
              ),
              ListTile(
                title: const Text('Bluetooth status'),
                subtitle: Text(_bluetoothState.toString()),
                trailing: ElevatedButton(
                  child: const Text('Settings'),
                  onPressed: () {
                    FlutterBluetoothSerial.instance.openSettings();
                  },
                ),
              ),
              ListTile(
                title: const Text('Local adapter address'),
                subtitle: Text(_address),
              ),
              ListTile(
                title: const Text('Local adapter name'),
                subtitle: Text(_name),
                onLongPress: null,
              ),
              ListTile(
                title: _discoverableTimeoutSecondsLeft == 0
                    ? const Text("Discoverable")
                    : Text(
                    "Discoverable for ${_discoverableTimeoutSecondsLeft}s"),
                subtitle: const Text("PsychoX-Luna"),
              ),
              ListTile(
                title: const Text('Bluetooth device connected?'),
                subtitle: Text(_connectionState),
              ),
              const Divider(),
              const ListTile(title: Text('Devices discovery and connection')),
              ListTile(
                title: ElevatedButton(
                  child: const Text('Connect/Disconnect a paired device.'),
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const SelectBondedDevicePage(checkAvailability: false);
                        },
                      ),
                    ).then((value){
                      if (value != null) {
                        _snackBarAlert(message: '${value.name} was selected', type: AlertType.success);
                        log('Connect -> selected ${value.address}');
                        context.read<BluetoothController>().connect(value);
                        // _startChat(context, value);
                      } else {
                        _snackBarAlert(message: 'No device selected');
                        log('Connect -> no device selected');
                      }
                    });
                  },
                ),
              ),
            ],
          );
        }
    );
  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server);
        },
      ),
    );
  }
}
