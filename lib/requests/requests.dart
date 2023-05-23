class Requests{
  static const addr = "104.248.63.15";
  static const baseUrl = 'http://$addr/api/';
  static Uri getUrl(String url) => Uri.parse(baseUrl+url);
  static Map<String, String>headers = {
    "Content-type": "application/json",
    "Accept": "application/json",
    'X-Requested-With': 'XMLHttpRequest',
  };

  static setHeader(String key, String value){
    headers[key] = value;
  }
}