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

  Future getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
