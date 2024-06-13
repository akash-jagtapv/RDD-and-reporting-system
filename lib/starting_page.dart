import "package:flutter/material.dart";
import "package:model_usage_demo_app/Admin/admin_sign_in_screen.dart";
import "package:model_usage_demo_app/Auth/sign_in.dart";

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
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
            myBtn(
                title: "Admin",
                ontap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const AdminLoginScreen();
                  }));
                }),
            const SizedBox(
              height: 30,
            ),
            myBtn(
                title: "User",
                ontap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const LoginScreen();
                  }));
                }),
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
