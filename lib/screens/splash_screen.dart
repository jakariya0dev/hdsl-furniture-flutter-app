import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hdsl/screens/home_screen.dart';
import 'package:hdsl/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    if (checkUser() == true) {
      MyUser().addUser();
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/furniture_logo.png',
              height: 120,
              width: 120,
            ),
            const SizedBox(
              height: 32,
            ),
            const Text(
              'HDSL',
              style: TextStyle(fontSize: 30, fontFamily: 'lobster'),
            ),
            const Text(
              'Furniture',
              style: TextStyle(fontSize: 30, fontFamily: 'pacifico'),
            ),
          ],
        ),
      ),
    );
  }

  Future checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isUeserLogedIn = prefs.getBool('isUeserLogedIn');
    return isUeserLogedIn;
  }
}
