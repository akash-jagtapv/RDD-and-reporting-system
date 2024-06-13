import 'package:model_usage_demo_app/Admin/admin_complaints_screen.dart';
import 'package:model_usage_demo_app/Admin/admin_profilepage.dart';
import 'package:model_usage_demo_app/starting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String uid = "UID";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      uid = _firebaseAuth.currentUser!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("RDD Model",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().whenComplete(() =>
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const StartingPage())));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(30),
        margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            myBtn(
                title: "View Complaints",
                ontap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const AdminComplaint();
                  }));
                }),
            const SizedBox(
              height: 30,
            ),
            // myBtn(
            //     title: "Profile Page",
            //     ontap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const AdminProfilePage()),
            //       );
            //     }),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget myBtn({required String title, required Function ontap}) {
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 200,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 17,
        ),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
