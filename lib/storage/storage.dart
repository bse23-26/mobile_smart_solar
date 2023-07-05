import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage{
  static Storage instance = Storage._();
  Storage._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _definitionsKey = 'definitions';

  Future<void> _writeStr(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String> _readStr(String key) async{
    return (await _storage.read(key: key))!;
  }

  Future<void> _writeJson(String key, Map<String, dynamic> json) async {
    await _storage.write(key: key, value: jsonEncode(json));
  }

  Future<Map<String, dynamic>> _readJson(String key) async {
    return jsonDecode((await _storage.read(key: key)).toString()) as Map<String, dynamic>;
  }

  Future<void> write(String key, dynamic data) async {
    String dataType = (data is Map)?'json':'string';

    Map<String, dynamic> definitions = {};
    if(await _storage.containsKey(key: _definitionsKey)){
      definitions = await _readJson(_definitionsKey);
    }
    definitions[key] = dataType;
    await _writeJson(_definitionsKey, definitions);
    (dataType=='json')?await _writeJson(key, data as Map<String, dynamic>):await _writeStr(key, data.toString());
  }

  Future<StorageData> read(String key) async {
    if(await _storage.containsKey(key: key)){
      Map<String, dynamic> definitions = await _readJson(_definitionsKey);
      StorageDataType dataType = (definitions[key]! =='json')?StorageDataType.json:StorageDataType.string;
      return StorageData(dataType:dataType, data:(dataType == StorageDataType.json)?(await _readJson(key)):(await _readStr(key)));
    }

    return StorageData(dataType:StorageDataType.undefined, data:null);
  }

  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  Future<bool> containsKeys(String key){
    return _storage.containsKey(key: key);
  }
}

enum StorageDataType { string, json, undefined }

class StorageData{
  StorageData({required this.dataType, required this.data});
  final StorageDataType dataType;
  final dynamic data;
}