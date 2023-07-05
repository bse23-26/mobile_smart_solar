import '../requests/requests.dart';

class User{
  static String? tel;
  static String? email;
  static String? deviceId;
  static String? name;
  static String? id;
  static String? token;
  static String? fcmToken;

  static Map<String, dynamic> toMap(){
    return (tel == null)?{}:{
      'tel': tel!,
      'email': email!,
      'name': name!,
      'deviceId': deviceId!,
      'id': id!,
      'token': token!,
      'fcmToken': fcmToken
    };
  }

  static void fromMap(Map<String, dynamic> map){
    tel = map['tel'].toString();
    email = map['email'].toString();
    deviceId = map['deviceId'].toString();
    id = map['id'].toString();
    name = map['name'].toString();
    token = map['token'].toString();
    fcmToken = map['fcmToken'].toString();
    Requests.setHeader('Authorization', 'Bearer $token');
  }

  static void invalidate(){
    tel = null;
    email = null;
    deviceId = null;
    id = null;
    name = null;
    token = null;
    fcmToken = null;
  }
}