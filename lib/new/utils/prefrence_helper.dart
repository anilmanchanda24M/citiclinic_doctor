import 'dart:convert';
import 'package:city_clinic_doctor/chat_section/utils/configs.dart';
import 'package:city_clinic_doctor/modal/profile/UserDetailResponse.dart';
import 'package:city_clinic_doctor/new/customs/logger_global.dart';
import 'package:city_clinic_doctor/ui/auth/bloc/LoginBloc.dart';
import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String PREFERENCE_KEY='current_user';

class PreferenceHelper {

  static Future<String> getString(String key) async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(key) ?? "";
    return token;
  }

  static saveString(String key, String value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static saveUser(UserData user) async {
    print('PreferenceHelper SAVED-$user');
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    try{
      _prefs.setString(PREFERENCE_KEY, jsonEncode(user));

    }catch(e){
      gLogger.e(e);
    }
    print('--------PreferenceHelper SAVED SUCCESS ${jsonEncode(user)}');
    var k=_prefs.getString(PREFERENCE_KEY);
    print('PreferenceHelper SAVED SUCCESS----- $k');
  }

  static Future<UserData> getUser() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    dynamic s;
    var k=_prefs.getString(PREFERENCE_KEY);
    print('gGetUserFromStorage-$k');
    try {
      var ss = _prefs.containsKey(PREFERENCE_KEY)
          ? _prefs.getString(PREFERENCE_KEY)
          : null;
      s = jsonDecode(ss);
      print('getUser-$ss');
      print('getUser-$s');
    } catch (e) {
      print("Exe $e");
      print(e);
    }
    currentUser.value.user=UserData.fromJson(s);
    currentUser.notifyListeners();
    // AppUtils.currentUser=ss;
    return s == null ? null : UserData.fromJson(s);
  }
  static Future<bool> logout() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey(PREFERENCE_KEY)) {
      return await _prefs.remove(PREFERENCE_KEY);
    } else {
      return false;
    }
  }

  static Future<CubeUser> getCUser() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    dynamic s;
    try {
      var ss = _prefs.containsKey("CUBE_KEY") ? _prefs.getString("CUBE_KEY") : null;
      if (ss == null) {
        return null;
      }
      s = jsonDecode(ss);
    } catch (e) {
      print(e);
    }
    return s == null ? null : CubeUser.fromJson(s);
  }



  static saveCUser(CubeUser cubeUser) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("CUBE_KEY", jsonEncode(cubeUser));
  }

}