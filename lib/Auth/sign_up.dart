import 'package:model_usage_demo_app/Auth/firestore_helper.dart';
import 'package:model_usage_demo_app/Auth/sign_in.dart';
import 'package:model_usage_demo_app/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email = "", password = "", name = "", confirmPassword = "", age = "";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isVisible1 = true, _isVisible2 = true;

  createAccount() async {
    if (password != "" &&
        confirmPassword != "" &&
        password == confirmPassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.toLowerCase(), password: password);
        String uid = FirebaseAuth.instance.currentUser!.uid;

        String user = _emailController.text.replaceAll("@gmail.com", " ");

        String id = randomAlphaNumeric(10);

        Map<String, dynamic> userData = {
          "Name": _nameController.text.trim(),
          "Email": _emailController.text.trim().toLowerCase(),
          "Username": user.toLowerCase(),
          "Photo":
              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
          "Id": id
        };
        FireStoreHelper().addUserDetails(userData, uid);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User Created Successfully")));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Home()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Password Length should be atleast 6")));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Email Already Exist")));
        }
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
            height: mq.height * .3,
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
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Sign-Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                const Center(
                  child: Text(
                    "Create a new Account ",
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
                      width: mq.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Container(
                          height: mq.height * 0.64,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Name",
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
                                      if (value == null || value.isEmpty) {
                                        return "Enter Name";
                                      }
                                      return null;
                                    },
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                        hintText: "Name",
                                        prefixIcon: Icon(Icons.person),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15)),
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter Email";
                                      }
                                      return null;
                                    },
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                        hintText: "Email",
                                        prefixIcon: Icon(Icons.email),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15)),
                                  )),
                              const SizedBox(
                                height: 15,
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
                                      if (value == null || value.isEmpty) {
                                        return "Enter Password";
                                      }
                                      return null;
                                    },
                                    controller: _passwordController,
                                    obscureText: _isVisible1,
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: _isVisible1
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isVisible1 = false;
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.visibility_outlined))
                                            : IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isVisible1 = true;
                                                  });
                                                },
                                                icon: const Icon(Icons
                                                    .visibility_off_outlined)),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15)),
                                  )),
                              const SizedBox(height: 15),
                              const Text(
                                "Confirm Password",
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
                                      if (value == null || value.isEmpty) {
                                        return "Enter Password again";
                                      }
                                      return null;
                                    },
                                    controller: _confirmPasswordController,
                                    obscureText: _isVisible2,
                                    decoration: InputDecoration(
                                        hintText: "Confirm Your Password",
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: _isVisible2
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isVisible2 = false;
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.visibility_outlined))
                                            : IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isVisible2 = true;
                                                  });
                                                },
                                                icon: const Icon(Icons
                                                    .visibility_off_outlined)),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15)),
                                  )),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Already have an account?",
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
                                              builder: (context) =>
                                                  const LoginScreen()));
                                    },
                                    child: const Text(
                                      "Sign-In",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        email = _emailController.text.trim();
                        name = _nameController.text.trim();
                        password = _passwordController.text.trim();
                        confirmPassword =
                            _confirmPasswordController.text.trim();
                      });

                      createAccount();
                    }
                  },
                  child: Center(
                    child: SizedBox(
                      width: mq.width * 0.4,
                      child: Material(
                        borderRadius: BorderRadius.circular(15),
                        elevation: 5,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue,
                          ),
                          child: const Text(
                            "Create Account",
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
        ],
      ),
    );
  }
}
