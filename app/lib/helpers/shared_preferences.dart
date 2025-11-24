import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static SharedPreferences? _sharedPrefs;
  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  bool getFirstTime() {
    bool firstTime = true;

    if (_sharedPrefs != null && _sharedPrefs!.getBool('firstTime') != null) {
      firstTime = _sharedPrefs!.getBool('firstTime')!;
    }

    return firstTime;
  }

  void setFirstTime(bool value) {
    if (_sharedPrefs != null) {
      _sharedPrefs!.setBool('firstTime', value);
    }
  }

  Map? getUserLoginData({bool temp = false}) {
    Map? userModel;
    String userData = sharedPrefs.getSharedPreferences(temp ? 'mercenary_UT_BIOMETRIC_TEMP' : 'mercenary_UT');

    if (userData != '') {
      userModel = userModel;
    }
    return userModel;
  }

  String getSharedPreferences(key) {
    String value = '';

    if (_sharedPrefs != null && _sharedPrefs!.getString(key) != null) {
      value = _sharedPrefs!.getString(key)!;
    }

    return value;
  }

  void setSharedPreferences(String key, String value) {
    if (_sharedPrefs != null) {
      _sharedPrefs!.setString(key, value);
    }
  }

  void remove(String key) {
    if (_sharedPrefs != null) {
      _sharedPrefs!.remove(key);
    }
  }
}

final sharedPrefs = MySharedPreferences();
