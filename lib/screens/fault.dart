import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smart_solar/controllers/fault_controller.dart';

import 'package:smart_solar/app_styles.dart';

class Fault extends StatefulWidget {
  const Fault({Key? key}) : super(key: key);

  @override
  State<Fault> createState() => _FaultState();
}

class _FaultState extends State<Fault> {
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  _submit(){
    Map<String, String> map = {
      'subject': _subject.text,
      'description': _description.text
    };
    FaultController.post(map).then((value){
      try {
        if (value['error']) {
          _snackBarAlert(value['res'], "error");
        } else {
          _snackBarAlert(value['res']['message'], "success");
          _subject.text = "";
          _description.text = "";
          // Navigator.of(context).pop();
        }
      }
      catch(p, e){
        log(e.toString());
      }
    });
  }

  _snackBarAlert(String message, String type){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: type=="error"?Colors.red:Colors.green),
          borderRadius: BorderRadius.circular(24),
        ),
        // elevation: 0,
        content: Text(message, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: type=="error"?Colors.red:Colors.green))
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Report fault', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _subject,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: 'Enter subject here',
                      ),

                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter The Subject';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: paddingHorizontal*2),
                    TextFormField(
                      controller: _description,
                      maxLines: 20,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: 'Enter fault description here',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter The Description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: paddingHorizontal*2),
                    Center(
                      child: ElevatedButton(
                          onPressed: (){
                            if(_form.currentState!.validate()){
                              _submit();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                          child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
