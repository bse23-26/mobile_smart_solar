class User{
  static String? phone;
  static String? email;
  static String? deviceId;
  static String? name;
  static String? id;
  static String? token;

  static Map<String, String> toMap(){
    return (phone == null)?{}:{
      'phone': phone!,
      'email': email!,
      'name': name!,
      'deviceId': deviceId!,
      'id': id!,
      'token': token!
    };
  }

  static void fromMap(Map<String, String> map){
    phone = map['phone'];
    email = map['email'];
    deviceId = map['deviceId'];
    id = map['id'];
    name = map['name'];
    token = map['token'];
  }

  static void invalidate(){
    phone = null;
    email = null;
    deviceId = null;
    id = null;
    name = null;
    token = null;
  }
}