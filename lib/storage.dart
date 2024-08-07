import 'package:shared_preferences/shared_preferences.dart';

class LocalAppStorage {
  static final LocalAppStorage _singleton = LocalAppStorage._internal();

  factory LocalAppStorage() {
    return _singleton;
  }

  LocalAppStorage._internal();

  void storeTempData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token',
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJzdSIsIm5iZiI6MTcwNzk3Njg1MywiZXhwIjoxNzM5NTk5MjUzfQ.taTVOm6OX1DCHDbRy-Ic64oAz8t__rUmKUu9QjnuQkc');
    prefs.setString('username', 'su');
    prefs.setBool('storage', true);
  }

  Future storeData(String token, String uname) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('username', uname);
    prefs.setBool('storage', true);
  }

  Future removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('username');
    prefs.remove('storage');
  }

  Future getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future getTouchIDEnable() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('touchID');
  }

  Future setTouchIDEnable(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('touchID', val);
  }

  Future setPermission(String val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('permission', val);
    return true;
  }

  Future isPermitted(String val) async {
    final prefs = await SharedPreferences.getInstance();
    final String? allPerm = prefs.getString('permission');
    List<String> a = (allPerm ?? "").split(",");
    return a.contains(val);
  }
}
