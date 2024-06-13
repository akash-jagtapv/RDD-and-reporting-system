// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:model_usage_demo_app/starting_page.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  // Dummy user data - replace with your data source
  final String username = 'user@example.com';
  final String name = 'John Doe';

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
                            builder: (_) => const StartingPage())));
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
