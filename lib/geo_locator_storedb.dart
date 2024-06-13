import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class DisplayLocationScreen extends StatefulWidget {
  const DisplayLocationScreen({super.key});

  @override
  State createState() => _DisplayLocationScreenState();
}

class _DisplayLocationScreenState extends State<DisplayLocationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Position? _currentPosition;
  String _locationMessage = "Getting Location...";
  String longitude = "", latitude = "", uid = "UID";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getUID();
  }

  void _getUID() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage =
            'Location permissions are permanently denied, we cannot request permissions.';
      });
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _locationMessage =
          'Location: \nLat: ${_currentPosition!.latitude}, \nLong: ${_currentPosition!.longitude}';
      latitude = _currentPosition!.latitude.toString();
      longitude = _currentPosition!.longitude.toString();
    });
  }

  void makeComplaint() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String username = await getUsername(uid);
      String email = user.email ?? '';

      DateTime now = DateTime.now();
      String date = "${now.day}/${now.month}/${now.year}";

      await _firestore.collection('complaints').add({
        'username': username,
        'email': email,
        'longitude': longitude,
        'latitude': latitude,
        'date': date,
        'status': 'Pending'
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Complaint submitted successfully!'),
      ));
    }
  }

  Future<String> getUsername(String uid) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
    return data['Name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: const Text("Geo Co-ordinations",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
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
                _locationMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () => MapsLauncher.launchCoordinates(
                  _currentPosition!.latitude, _currentPosition!.longitude),
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
                child: const Text(
                  "LAUNCH COORDINATES",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                makeComplaint();
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
                child: const Text(
                  "Register Complaint",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
