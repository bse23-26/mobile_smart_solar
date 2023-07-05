class Requests{
  static const addr = "solar.owekisa.org";
  static const baseUrl = 'https://$addr/api/';
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
