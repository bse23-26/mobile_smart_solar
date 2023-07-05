import 'package:smart_solar/helpers/helpers.dart';

class BatteryDataDefaults{
  static const double maxVoltage = 0.2;
  static const double minVoltage = 0.1;
  static const double availableVoltage = 0.1;
  static const double nominalVoltage = 0.1;
  static const double rating = 1;
  static const String ratingUnits = 'Ah';
  static const double percentage = 0;
  static const double current = -0.1;
  static const double time = 0;
  static const List<String> units = ['Ah', 'mAh', 'Wh', 'mWh'];
}

class Battery{
  static double maxVoltage = BatteryDataDefaults.maxVoltage;
  static double minVoltage = BatteryDataDefaults.minVoltage;
  static double _availableVoltage = BatteryDataDefaults.availableVoltage;
  static double _nominalVoltage = BatteryDataDefaults.nominalVoltage;
  static double _rating = BatteryDataDefaults.rating;
  static String _ratingUnits = BatteryDataDefaults.ratingUnits;
  static double _percentage = BatteryDataDefaults.percentage;
  static double _current = BatteryDataDefaults.current;
  static double _time = BatteryDataDefaults.time;

  static set availableVoltage(double available){
    if(available<(minVoltage-0.5)) {
      return;
    }
    _availableVoltage = available;
    double diffVoltage = maxVoltage-minVoltage;
    double varyDiffVoltage = _availableVoltage - minVoltage;
    _percentage = (varyDiffVoltage/diffVoltage)*100;
    if(_percentage<0){
      _percentage = 0;
      minVoltage = _availableVoltage;
    }
  }

  static set nominalVoltage(double nominalVoltage){
    _nominalVoltage = nominalVoltage;
    _calculateRating();
  }

  static setRating(double rating, String ratingUnits){
    _rating = rating;
    _ratingUnits = ratingUnits;
    _calculateRating();
  }

  static _calculateRating(){
    switch (_ratingUnits) {
      case 'Ah':
        return;
      case 'mAh':
        _rating = _rating / 1000;
        break;
      case 'Wh':
        _rating = _rating / _nominalVoltage;
        break;
      case 'mWh':
        _rating = _rating / (_nominalVoltage* 1000);
        break;
    }
    _ratingUnits = 'Ah';
  }

  static set current(double current){
    _current = current;
    _time = _rating/ _current;
  }

  static double get availableVoltage => _availableVoltage;

  static double get percentage => _percentage;

  static double get rating => _rating;

  static String get ratingWithUnits => "$_rating $_ratingUnits";

  static double get current => _current;
  
  static double get time => _time;

  static Map<String, dynamic> toMap(){
    return {
      'maxVoltage': maxVoltage.toString(),
      'minVoltage': minVoltage.toString(),
      'availableVoltage': _availableVoltage.toString(),
      'nominalVoltage': _nominalVoltage.toString(),
      'rating': _rating.toString(),
      'ratingUnits': _ratingUnits.toString(),
      'current': _current.toString(),
    };
  }

  static void fromMap(Map<String, dynamic> map){
    initFromMap(map);
    availableVoltage = toDouble(map['availableVoltage']);
    current = toDouble(map['current']);
  }

  static void initFromMap(Map<String, dynamic> map){
    maxVoltage = toDouble(map['maxVoltage']);
    minVoltage = toDouble(map['minVoltage']);
    nominalVoltage = toDouble(map['nominalVoltage']);
    setRating(toDouble(map['rating']), map['ratingUnits']!);

    // devConfig['maxVoltage'] = maxVoltage;
    // devConfig['minVoltage'] = minVoltage;
    // devConfig['nominalVoltage'] = map['nominalVoltage'];
    // devConfig['rating'] = map['rating'];
  }
}

class Powerline{
  String name;
  int state;
  String? alias;

  Powerline(this.name, this.state, this.alias){
    powerlines[name]=(this);
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'state': state.toString(),
      'alias': alias
    };
  }

  factory Powerline.fromMap(Map<String, dynamic> map){
    String name = map['name'].toString();
    int state = int.parse(map['state']!);
    String? alias = map['alias'];
    return Powerline(name, state, alias);
  }

  static Map<String, Powerline> powerlines = {};

  static List<Map<String, dynamic>> powerlinesToMapCollection(){
    List<Map<String, dynamic>> lines = [];

    powerlines.forEach((key, element) {
      lines.add(element.toMap());
    });
    return lines;
  }

  static void powerlinesFromMapList(List<dynamic> lines){
    powerlines = {};
    for (var element in lines) {
      Powerline.fromMap(element);
    }
  }

  static void updateState(Map<String, int> map){
    map.forEach((key, value) {
      powerlines[key]?.state = value;
      // devConfig[key] = value;
    });
  }

  static void updateAlias(Map<String, String> map){
    map.forEach((key, value) {
      powerlines[key]?.alias = value;
      // devConfig[key] = value;
    });
  }

}

Map<String, dynamic> devConfig = {};
