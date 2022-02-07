import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hdsl/const.dart';
import '../user.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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
              height: 30,
            ),
            Expanded(
              child: Image.asset(
                'assets/images/furniture_logo.png',
                height: 100,
                width: 100,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Sign Up',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
              controller: nameController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                  // icon: Icon(Icons.mail),
                  isDense: true,
                  prefixIcon: const Icon(Icons.account_box_sharp),
                  suffixIcon: nameController.text.isEmpty
                      ? const Text('')
                      : GestureDetector(
                          onTap: () {
                            nameController.clear();
                          },
                          child: const Icon(Icons.close)),
                  hintText: 'Your full name',
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
              keyboardType: TextInputType.number,
              controller: phoneController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                  // icon: Icon(Icons.mail),

                  isDense: true,
                  prefixIcon: const Icon(Icons.add_box),
                  suffixIcon: phoneController.text.isEmpty
                      ? const Text('')
                      : GestureDetector(
                          onTap: () {
                            phoneController.clear();
                          },
                          child: const Icon(Icons.close)),
                  hintText: 'Phone Number',
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
              controller: passwordController, //
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
              onPressed: () async {
                userRegistration();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text('Submit'),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Have you an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Login here')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> userRegistration() async {
    if (emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        var user = userCredential.user;
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        var userData = {
          'email': emailController.text,
          'name': nameController.text,
          'phone': phoneController.text,
        };
        await firestore.collection('users').doc(user?.email).set(userData);
        emailController.clear();
        nameController.clear();
        phoneController.clear();
        passwordController.clear();
        user_mail = user?.email;

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      userId: user?.uid,
                    )));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showWarnigDialog(warning: 'The password provided is too weak.');
          // print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showWarnigDialog(
              warning: 'The account already exists for that email.');
          // print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
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
