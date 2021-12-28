import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSharedPrefrences {
  static const String _keyEmail = 'emailPref';
  static const String _keyPassword = 'passwordPref';

  late String email;
  static Future<void> savePref(String email, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(_keyEmail, email);
    pref.setString(_keyPassword, password);
  }

  static Future<bool> getPref() async {
    final _auth = FirebaseAuth.instance;
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString(_keyEmail) != null) {
      String email = pref.getString(_keyEmail)!;
      String password = pref.getString(_keyPassword)!;
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        return true;
      } catch (e) {
        print(e.toString());
        return false;
      }
    }
    return false;
  }

  static Future<void> clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
