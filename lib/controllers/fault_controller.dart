import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:smart_solar/requests/requests.dart';

import '../models/user.dart';

class FaultController {
  static Future<Map<String, dynamic>> post(Map<String, String> data) async {
    try {
      var request = http.MultipartRequest('POST', Requests.getUrl('fault'));
      request.fields.addAll(data);
      request.fields.addAll({'token':User.token!});
      request.headers.addAll(Requests.headers);
      http.StreamedResponse response = await request.send();

      Map<String, Object> responseObj = {
        'error': false,
        'code': response.statusCode
      };

      if (response.statusCode == 200) {
        responseObj['res'] = jsonDecode(await response.stream.bytesToString()) as Map<String, dynamic>;
      }
      else if (response.statusCode == 422) {
        responseObj['error'] = true;
        responseObj['res'] =
        (jsonDecode(await response.stream.bytesToString()) as Map<
            String,
            dynamic>)['message'];
      }
      else {
        responseObj['error'] = true;
        responseObj['res'] = response.reasonPhrase!;
      }

      return responseObj;
    } catch (e, st) {
      return {'error': true, 'res': e.toString()};
    }
  }
}