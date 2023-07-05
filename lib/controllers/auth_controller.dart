import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:smart_solar/requests/requests.dart';
import 'package:smart_solar/storage/storage.dart';
import 'package:smart_solar/models/user.dart';

class AuthController{
  static Future<Map<String, dynamic>> login(Map<String, String> credentials) async {
    try {
      var request = http.MultipartRequest('POST', Requests.getUrl('login'));
      request.fields.addAll(credentials);
      request.headers.addAll(Requests.headers);
      http.StreamedResponse response = await request.send();

      Map<String, dynamic> responseObj = {'error':false, 'code':response.statusCode};
      if (response.statusCode == 200) {
        var resp = jsonDecode(await response.stream.bytesToString()) as Map<String, dynamic>;
        responseObj['res'] = resp;
        User.fromMap(resp);
        await Storage.instance.write('user', User.toMap());
      }
      else if(response.statusCode == 422) {
        responseObj['error'] = true;
        var res = (jsonDecode(await response.stream.bytesToString()));
        if(res.containsKey('message')){
          responseObj['res'] = res['message'];
        }else{
          responseObj['res'] = "";
          res.forEach((key, value) {
            responseObj['res'] += "${value[0]}\n";
          });
        }
      }
      else {
        responseObj['error'] = true;
        responseObj['res'] = response.reasonPhrase!;
      }

      return responseObj;
    } catch(e) {
      return {'error':true, 'res':e.toString()};
    }
  }

  static Future<Map<String, dynamic>> signUp(Map<String, String> credentials) async {
    try {
      var request = http.MultipartRequest('POST', Requests.getUrl('register'));
      request.fields.addAll(credentials);
      request.headers.addAll(Requests.headers);
      http.StreamedResponse response = await request.send();

      Map<String, dynamic> responseObj = {'error':false, 'code':response.statusCode};
      if (response.statusCode == 200) {
        var resp = jsonDecode(await response.stream.bytesToString()) as Map<String, dynamic>;
        responseObj['res'] = resp;
        User.fromMap(resp);
        await Storage.instance.write('user', User.toMap());
      }
      else if(response.statusCode == 422) {
        responseObj['error'] = true;
        var res = (jsonDecode(await response.stream.bytesToString()) as Map<String, dynamic>);
        if(res.containsKey('message')){
          responseObj['res'] = res['message'];
        }else{
          responseObj['res'] = "";
          res.forEach((key, value) {
            responseObj['res'] += "${value[0]}\n";
          });
        }
      }
      else {
        responseObj['error'] = true;
        responseObj['res'] = response.reasonPhrase!;
      }

      return responseObj;
    } catch(e) {
      return {'error':true, 'res':e.toString()};
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    try {
      var request = http.MultipartRequest('POST', Requests.getUrl('logout'));
      request.fields.addAll({'token':User.token!});
      request.headers.addAll(Requests.headers);
      http.StreamedResponse response = await request.send();

      Map<String, dynamic> responseObj = {'error':false, 'code':response.statusCode};
      if (response.statusCode == 200) {
        await Storage.instance.remove('user');
        User.invalidate();
      }
      else if(response.statusCode == 422) {
        responseObj['error'] = true;
        responseObj['res'] = (jsonDecode(await response.stream.bytesToString()) as Map<
            String,
            dynamic>)['message'];
      }
      else {
        responseObj['error'] = true;
        responseObj['res'] = response.reasonPhrase!;
      }

      return responseObj;
    } catch(e) {
      return {'error':true, 'res':e.toString()};
    }
  }
}