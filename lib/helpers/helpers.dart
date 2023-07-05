double toDouble(dynamic val){
  if(val is String){
    return double.parse(val);
  }
  return val.toDouble();
}