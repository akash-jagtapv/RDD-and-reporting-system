// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:model_usage_demo_app/Auth/firestore_helper.dart';
import 'package:model_usage_demo_app/starting_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
  userLogin() {}
}

class _ProfilePageState extends State<ProfilePage> {
  // Dummy user data - replace with your data source
  String username = 'user@example.com';
  String name = 'John Doe';

  String email = "", password = "";

  @override
  initState() {
    super.initState();
    // userLogin();
  }

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
    String? pic, id;

    try {
      QuerySnapshot querySnapshot =
          await FireStoreHelper().getUserbyEmail(email);

      name = "${querySnapshot.docs[0]["Name"]}";
      username = "${querySnapshot.docs[0]["Username"]}";
      pic = "${querySnapshot.docs[0]["Photo"]}";
      id = "${querySnapshot.docs[0]["Id"]}";
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   'Username: $username',
            //   style: const TextStyle(fontSize: 20),
            // ),
            const SizedBox(height: 30), // Provides spacing between text widgets
            // Text(
            //   'Name: $name',
            //   style: const TextStyle(fontSize: 20),
            // ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut().whenComplete(() =>
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const StartingPage())));
                // builder: (_) =>
                //     const StartingPage())));
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 200,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 17,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
