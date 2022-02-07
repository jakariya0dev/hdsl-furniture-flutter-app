// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hdsl/screens/login_screen.dart';

import '../user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? userEmail;
  String? userPhone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.all(24),
      constraints: BoxConstraints.expand(),
      child: userPhone == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  child: Icon(
                    Icons.person_outline,
                    size: 55,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(
                          width: 24,
                        ),
                        Text(userName!),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.mail),
                        const SizedBox(
                          width: 24,
                        ),
                        Text(userEmail!),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.phone),
                        const SizedBox(
                          width: 24,
                        ),
                        Text(userPhone!),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: Colors.green,
                        onPressed: () => editProfile(),
                        child: const Text('Edit Profile'),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: MaterialButton(
                        color: Colors.blueAccent,
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: const Text('Log out'),
                      ),
                    ),
                  ],
                )
              ],
            ),
    ));
  }

  editProfile() {
    TextEditingController nameController =
        TextEditingController(text: userName);
    TextEditingController phoneController =
        TextEditingController(text: userPhone);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(icon: Icon(Icons.person_outline)),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(icon: Icon(Icons.phone)),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                    firestore.collection('users').doc(user_mail).update({
                      'name': nameController.text,
                      'phone': phoneController.text
                    });

                    getUserData();
                    Navigator.pop(context);
                  },
                  child: Text('Ok')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
            ],
          );
        });
  }

  void getUserData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var userdata = await firestore.collection('users').doc(user_mail).get();
    userName = userdata['name'];
    userEmail = userdata['email'];
    userPhone = userdata['phone'];
    setState(() {});
    // print(userdata['name']);
  }
}
