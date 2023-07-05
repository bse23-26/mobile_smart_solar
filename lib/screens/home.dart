import 'package:flutter/material.dart';
import 'package:smart_solar/screens/power/power_screen.dart';
import 'package:smart_solar/screens/bluetooth/BluetoothMainScreen.dart';
import 'package:smart_solar/screens/notifications.dart';
import 'account.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.pageName=''}) : super(key: key);
  final String pageName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    if(widget.pageName == 'notifications'){
      _selectedIndex = 2;
    }
  }

  static const List<Widget> _widgetOptions = <Widget>[
    BluetoothMainScreen(),
    BatteryScreen(),
    NotificationScreen(),
    Account(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Bluetooth',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.battery_4_bar_outlined),
            label: 'Battery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
