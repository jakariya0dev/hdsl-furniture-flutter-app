import 'package:hdsl/const.dart';
import 'package:hdsl/screens/home_screen.dart';
import 'package:hdsl/screens/reg_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Image.asset(
              'assets/images/furniture_logo.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Login to Your account',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'cormorant'),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: emailController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                  // icon: Icon(Icons.mail),
                  isDense: true,
                  prefixIcon: const Icon(Icons.mail),
                  suffixIcon: emailController.text.isEmpty
                      ? const Text('')
                      : GestureDetector(
                          onTap: () {
                            emailController.clear();
                          },
                          child: const Icon(Icons.close)),
                  hintText: 'abc@mail.com',
                  // labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1))),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              obscureText: isVisible,
              controller: passwordController,

              //
              decoration: InputDecoration(
                  // icon: Icon(Icons.mail),
                  isDense: true,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        isVisible = !isVisible;
                        setState(() {});
                      },
                      child: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off)),
                  hintText: 'your password',
                  // labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1))),
            ),
            const SizedBox(
              height: 16,
            ),
            MaterialButton(
              shape: const StadiumBorder(),
              color: Colors.blueAccent,
              onPressed: () {
                getData();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text('Submit'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RegScreen()));
                    },
                    child: const Text('Create one')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        var user = userCredential.user;
        if (user?.uid != null) {
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          user_mail = user?.email;
          user_id = user?.uid;

          var userdata =
              await firestore.collection('users').doc(user_mail).get();

          user_name = userdata['name'];
          user_phone = userdata['phone'];

          MyUser().addUser();

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        userId: user?.uid,
                      )));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // print('No user found for that email.');
          showWarnigDialog(warning: 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showWarnigDialog(warning: 'Wrong password provided for that user.');
          // print('Wrong password provided for that user.');
        }
      }
    } else {
      showWarnigDialog(warning: 'Please fill all the field');
    }
  }

  void showWarnigDialog({required String warning}) {
    showDialog(
        context: context,
        builder: (
          context,
        ) {
          return AlertDialog(
            title: const Text(
              'WARNING!',
              style: TextStyle(color: Colors.red),
            ),
            content: Text(warning),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ok'))
            ],
          );
        });
  }
}
