import 'package:shared_preferences/shared_preferences.dart';

class PrefData {
  static String prefName = "com.example.event_app";

  static String isSelect = "${prefName}isSelect";

  static setIsFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isFirstTime", false);
  }

  static isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool("isFirstTime") ?? true;
    return intValue;
  }

  static getSelectInterest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isSelect) ?? false;
  }

  static setSelectInterest(bool isFav) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isSelect, isFav);
  }
}
