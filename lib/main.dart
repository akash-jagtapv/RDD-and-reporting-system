import 'package:model_usage_demo_app/firebase_options.dart';
import 'package:model_usage_demo_app/starting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:model_usage_demo_app/home.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
          future: getCurrentUser(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return const Home();
            } else {
              return const StartingPage();
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}
