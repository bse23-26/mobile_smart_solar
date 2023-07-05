import 'package:flutter/material.dart';
import 'package:smart_solar/controllers/auth_controller.dart';
import 'package:smart_solar/app_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_solar/routes/route_names.dart';

import '../models/user.dart';

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  _launchNative(BuildContext context, String application, Uri url){
    canLaunchUrl(url).then((value){
      (value)?launchUrl(url):_snackBarAlert(context, 'Could not launch $application');
    });
  }

  _snackBarAlert(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.red),
          borderRadius: BorderRadius.circular(24),
        ),
        // elevation: 0,
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red))
    ));
  }

  _logout(BuildContext context){
    AuthController.logout().then((value){
      if(value['error']){
        _snackBarAlert(context, value['res']);
      }else{
        Navigator.pushReplacementNamed(context, Routes.auth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal*1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('My Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            SizedBox(height: paddingHorizontal),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, // Your desired background color
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                  ]
              ),
              child: ListTile(
                isThreeLine: true,
                leading: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle,color: Colors.blue, size: 40),
                  ],
                ),
                title: Text(User.name!, style: const TextStyle(fontSize: 18)),
                subtitle: Text('${User.tel!} \n${User.email!}', style: const TextStyle(fontSize: 16, color: Colors.black87)),
                minLeadingWidth: 1,
              ),
            ),
            SizedBox(height: paddingHorizontal*2),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white, // Your desired background color
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                    ]
                ),
              child: Column(
                children: [
                  const Divider(color: Colors.white),
                  ListTile(
                    isThreeLine: false,
                    dense: true,
                    leading: const Icon(Icons.solar_power_sharp, color: Colors.blue, size: 30),
                    title: const Text('Device Details', style: TextStyle(fontSize: 18)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue),
                    minLeadingWidth: 1,
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: const Text('Device Id'),
                              content: Text(User.deviceId!),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    },
                  ),
                  const Divider(color: Colors.black54, indent: 20, endIndent: 20),
                  ListTile(
                    isThreeLine: false,
                    dense: true,
                    leading: const Icon(Icons.help, color: Colors.blue, size: 30),
                    title: const Text('Report fault', style: TextStyle(fontSize: 18)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue),
                    minLeadingWidth: 1,
                    onTap: (){
                      Navigator.of(context).pushNamed(Routes.fault);
                    },
                  ),
                  const Divider(color: Colors.black54, indent: 20, endIndent: 20),
                  ListTile(
                    isThreeLine: false,
                    dense: true,
                    leading: const Icon(Icons.info, color: Colors.blue, size: 30),
                    title: const Text('About', style: TextStyle(fontSize: 18)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue),
                    minLeadingWidth: 1,
                    onTap: (){
                      showAboutDialog(
                          context: context,
                        applicationName: 'SmartSolar',
                        applicationVersion: 'version 1.0',
                        applicationIcon: Image.asset('assets/logo.png', width: 60, height: 60),
                        children: [
                          const Column(
                            children: [
                              Text('Made By BSE23-26'),
                              SizedBox(height: 5),
                              Text('Engineers:', style: TextStyle(color: Colors.blue, fontSize: 20)),
                              Text('Rashidah Magezi Tumukunde'),
                              Text('Kibalama Timothy'),
                              Text('Ddamba Mahad'),
                              Text('Mwesigwa Joshua'),
                            ],
                          ),
                        ]
                      );
                    },
                  ),
                  const Divider(color: Colors.black54, indent: 20, endIndent: 20),
                  const Center(child: Text('Contact Us', style: TextStyle(fontSize: 20))),
                  SizedBox(height: paddingHorizontal),
                  Wrap(
                    spacing: 30,
                    children: [
                      InkWell(
                          child: Image.asset('assets/whatsapp.png', width: 40, height: 40),
                        onTap: (){
                          _launchNative(context, 'WhatsApp', Uri.parse("whatsapp://send?phone=+256700216664"));
                        },
                      ),
                      InkWell(
                          child: Image.asset('assets/twitter.png', width: 40, height: 40),
                        onTap: (){
                          _launchNative(context, 'Twitter', Uri.parse("https://twitter.com/timothykibalam1"));
                        },
                      ),
                      InkWell(
                          child: const Icon(Icons.alternate_email, size: 40, color: Colors.green),
                        onTap: (){
                            _launchNative(context, 'Email Client', Uri.parse("mailto:timkibalama@gmail.com"));
                        },
                      ),
                      InkWell(
                          child: const Icon(Icons.phone, size: 40, color: Colors.blue),
                        onTap: (){
                          _launchNative(context, 'Phone App', Uri.parse("tel:+256700216664"));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: paddingHorizontal*3)
                ],
              ),
            ),
            SizedBox(height: paddingHorizontal*2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 60, height: 60),
                const Text('SmartSolar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
              ],
            ),
            SizedBox(height: paddingHorizontal),
            const Center(child: Text('Version 1.0', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22))),
            SizedBox(height: paddingHorizontal),
            Center(
              child: ElevatedButton(
                  onPressed: (){_logout(context);},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  child: const Text('Log out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
              ),
            ),
          ],
        ),
    );
  }
}
