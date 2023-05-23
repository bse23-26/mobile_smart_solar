import 'package:flutter/material.dart';
import 'package:smart_solar/controllers/auth_controller.dart';
import 'package:smart_solar/routes/route_names.dart';
import 'package:smart_solar/app_styles.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool _loginHidePass = true;
  final TextEditingController _phoneOrEmail = TextEditingController();
  final TextEditingController _loginPassword = TextEditingController();
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();

  bool _signHidePass = true;
  bool _hideConfirmPass = true;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _deviceId = TextEditingController();
  final TextEditingController _signPassword = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final GlobalKey<FormState> _signForm = GlobalKey<FormState>();

  _snackBarAlert(String message){
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

  bool _validateEmail(String value) {
    const String pattern =
        "^[a-zA-Z0-9.!#\$%&'+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)\$";
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  bool _validatePhone(String value) {
    const String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  _login(){
    Map<String, String> credentials = {
      'password': _loginPassword.text
    };
    credentials[_validateEmail(_phoneOrEmail.text)?'email':'phone'] = _phoneOrEmail.text;

    AuthController.login(credentials).then((value){
      if(value['error']){
        _snackBarAlert(value['res']);
      }else{
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    });
  }

  _signUp(){
    AuthController.signUp({
      'name': _name.text,
      'phone': _phone.text,
      'email': _email.text,
      'deviceId': _deviceId.text,
      'password': _signPassword.text
    }).then((value){
      if(value['error']){
        _snackBarAlert(value['res']);
      }else{
        Navigator.pushReplacementNamed(context, Routes.home);
      }
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal*2),
          child: Column(
            children: [
              Form(
                key: _loginForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: paddingHorizontal),
                   const Text('Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    SizedBox(height: paddingHorizontal),
                    TextFormField(
                      controller: _phoneOrEmail,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.account_circle),
                        border: OutlineInputBorder(),
                        hintText: 'Email Or Phone',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Email or Phone';
                        }

                        if(!(_validateEmail(value) || _validatePhone(value))){
                          return 'Please Enter Valid Phone Or Email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: paddingHorizontal),
                    TextFormField(
                      controller: _loginPassword,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          child: Icon(_loginHidePass?Icons.visibility_rounded:Icons.visibility_off_rounded),
                          onTap: () {
                            setState(() {
                              _loginHidePass = !_loginHidePass;
                            });
                          },
                        ),

                        border: const OutlineInputBorder(),
                        hintText: 'Password',
                      ),
                      obscureText: _loginHidePass,
                      enableSuggestions: true,

                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: paddingHorizontal),
                    Center(
                      child: ElevatedButton(
                          onPressed: (){
                            if (_loginForm.currentState!.validate()) {
                              _login();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                          child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
                      ),
                    ),
                    SizedBox(height: paddingHorizontal),
                  ],
                ),
              ),
              Form(
                key: _signForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Or Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    SizedBox(height: paddingHorizontal),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.account_circle_outlined),
                        border: OutlineInputBorder(),
                        hintText: 'Name',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: paddingHorizontal),
                    TextFormField(
                      controller: _phone,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                        hintText: 'Phone',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Phone Number';
                        }

                        if(!_validatePhone(value)){
                          return 'Please Enter a Valid Phone Number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: paddingHorizontal),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.alternate_email),
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Email';
                        }

                        if(!_validateEmail(value)){
                          return 'Please Enter Valid Email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: paddingHorizontal),
                    TextFormField(
                      controller: _deviceId,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.solar_power_sharp),
                        border: OutlineInputBorder(),
                        hintText: 'Device Id',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Device Id';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: paddingHorizontal),
                    TextFormField(
                      controller: _signPassword,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          child: Icon(_signHidePass?Icons.visibility_rounded:Icons.visibility_off_rounded),
                          onTap: () {
                            setState(() {
                              _signHidePass = !_signHidePass;
                            });
                          },
                        ),

                        border: const OutlineInputBorder(),
                        hintText: 'Password',
                      ),
                      obscureText: _signHidePass,
                      enableSuggestions: true,

                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        else if(value.length<8){
                          return 'At least 8 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: paddingHorizontal),
                    TextFormField(
                      controller: _confirmPass,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          child: Icon(_hideConfirmPass?Icons.visibility_rounded:Icons.visibility_off_rounded),
                          onTap: () {
                            setState(() {
                              _hideConfirmPass = !_hideConfirmPass;
                            });
                          },
                        ),

                        border: const OutlineInputBorder(),
                        hintText: 'Confirm Password',
                      ),
                      obscureText: _hideConfirmPass,
                      enableSuggestions: true,

                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if(value != _signPassword.text) {
                          return 'Passwords do not match';
                        } else if(value.length<8){
                          return 'At least 8 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: paddingHorizontal),
                    Center(
                      child: ElevatedButton(
                          onPressed: (){
                            if (_signForm.currentState!.validate()) {
                              _signUp();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                          child: const Text('SignUp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
