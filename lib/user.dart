import 'package:shared_preferences/shared_preferences.dart';

var user_id;
var user_name;
var user_phone;
var user_mail;

class MyUser {
  addUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', user_id);
    prefs.setString('userName', user_name);
    prefs.setString('userPhone', user_phone);
    prefs.setString('userMail', user_mail);
    prefs.setBool('isUserLogedIn', true);
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('userId');
    user_name = prefs.getString('userName');
    user_phone = prefs.getString('userPhone');
    user_mail = prefs.getString('userMail');
  }

  removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isUserLogedIn', false);
  }
}
