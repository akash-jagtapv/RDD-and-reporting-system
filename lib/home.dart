import 'package:model_usage_demo_app/complaint_screen.dart';
// import 'package:model_usage_demo_app/starting_page.dart';
import 'package:model_usage_demo_app/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:flutter/material.dart';
import 'geo_locator_storedb.dart';
import 'dart:io';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image = File("asset/flutterLogo.jpg");
  bool _isOutputEmpty = false;
  // List _output = [
  //   "",
  // ];
  late List _output;
  final picker = ImagePicker();
  String uid = "UID";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int _selectIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      uid = _firebaseAuth.currentUser!.uid;
    });

    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _output = output!;
      _loading = false;

      if (_output[0]['label'] == "pothole") {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => const DisplayLocationScreen()),
        // );
        _isOutputEmpty = true;
      } else {
        _isOutputEmpty = false;
      }
    });
  }

  displayLocationScreen() {
    if (_isOutputEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DisplayLocationScreen()),
      );
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'asset/final-model_unquant.tflite',
      labels: 'asset/final-labels.txt',
    );
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white70,
          unselectedItemColor: Colors.black,
          selectedFontSize: 12.0,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blue[300],
          onTap: (int index) {
            setState(() {
              _selectIndex = index;

              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ComplaintListScreen()),
                );
              }
              if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              }
            });
          },
          currentIndex: _selectIndex,
          items: [
            BottomNavigationBarItem(
              icon: _selectIndex == 0
                  ? const Icon(Icons.home)
                  : const Icon(Icons.home_outlined),
              label: 'Home',
              backgroundColor: Colors.blueGrey,
            ),
            BottomNavigationBarItem(
              icon: _selectIndex == 1
                  ? const Icon(Icons.comment)
                  : const Icon(Icons.comment_outlined),
              label: 'Complaints',
              backgroundColor: Colors.blueGrey,
            ),
            BottomNavigationBarItem(
              icon: _selectIndex == 2
                  ? const Icon(Icons.person)
                  : const Icon(Icons.person_outlined),
              label: 'Profile',
              backgroundColor: Colors.blueGrey,
            )
          ],
        ),
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
              Center(
                child: _loading == true
                    ? null
                    : Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.5,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.file(
                                _image,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          _output != null
                              ? Text(
                                  "output:  ${_output[0]['label']}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Container(),
                          const Divider(
                            height: 25,
                            thickness: 1,
                          ),
                        ],
                      ),
              ),
              Column(
                children: [
                  myBtn(title: "Take Picture", ontap: pickImage),
                  const SizedBox(
                    height: 30,
                  ),
                  myBtn(title: "Pick From Gallery", ontap: pickGalleryImage),
                  const SizedBox(
                    height: 30,
                  ),
                  myBtn(
                    title: "Register Complaint",
                    ontap: displayLocationScreen,
                  ),
                ],
              ),
            ],
          ),
        ));
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
