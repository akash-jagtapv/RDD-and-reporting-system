import 'package:model_usage_demo_app/Auth/firestore_helper.dart';
import 'package:model_usage_demo_app/Auth/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:model_usage_demo_app/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "", password = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isVisible = true;

  userLogin() async {
    try {
      _emailController.clear();
      _passwordController.clear();

      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print(e.message);
        }
      }
      String? name, username, pic, id;

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

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return const Home();
      }
          //   builder: (BuildContext context) {
          // return const Home();}
          ));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("User Does Not Exist")));
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Wrong Password")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: mq.height / 4,
            width: mq.width,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(mq.width, 105))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                const Center(
                  child: Text(
                    "Please sign in to continue",
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      height: mq.height / 1.8,
                      width: mq.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Email",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.black54),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  onTap: () {},
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value == "") {
                                      return "Please Enter Email";
                                    }
                                    // if (value != null &&
                                    //     value.length > 6 &&
                                    //     value !=
                                    //         RegExp(r'^[^@]+@[^@]+\.[^@]+')) {
                                    //   return "Enter valid email";
                                    // }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "Email",
                                      prefixIcon: Icon(Icons.email_outlined),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15)),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Password",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.black54),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  onTap: () {},
                                  validator: (value) {
                                    if (value == null || value == "") {
                                      return "Please Enter Password";
                                    }
                                    if (value != null && value.length < 6) {
                                      return "Password should Atleast be 6 characters";
                                    }
                                    return null;
                                  },
                                  controller: _passwordController,
                                  obscureText: _isVisible,
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      prefixIcon:
                                          const Icon(Icons.lock_outlined),
                                      suffixIcon: _isVisible
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isVisible = false;
                                                });
                                              },
                                              icon: const Icon(
                                                  Icons.visibility_outlined))
                                          : IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isVisible = true;
                                                });
                                              },
                                              icon: const Icon(Icons
                                                  .visibility_off_outlined)),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15)),
                                )),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (_) {
                                //   return const Forget();
                                // }));
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: const Text(
                                  "Forget Password ?",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    email = _emailController.text.trim();
                                    password = _passwordController.text.trim();
                                  });
                                }
                                if (_emailController.text.isNotEmpty &&
                                    _passwordController.text.isNotEmpty) {
                                  userLogin();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please Fill Login Details")));
                                }
                              },
                              child: Center(
                                child: SizedBox(
                                  width: 130,
                                  child: Material(
                                    elevation: 5,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(10),
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blue,
                                      ),
                                      child: const Text(
                                        "SignIn",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
