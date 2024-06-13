import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter/material.dart';

class AdminComplaint extends StatefulWidget {
  const AdminComplaint({super.key});

  @override
  State<AdminComplaint> createState() => _AdminComplaintState();
}

class _AdminComplaintState extends State<AdminComplaint> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Complaints'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Column(children: [
                  Icon(Icons.pending),
                  Text("Pending Complaints"),
                ]),
              ),
              Tab(
                icon: Column(children: [
                  Icon(Icons.check),
                  Text("Resolved Complaints"),
                ]),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: myStreamBuilder(status: 'Pending'),
            ),
            Center(
              child: myStreamBuilder(status: 'Completed'),
            ),
          ],
        ),
      ),
    );
  }

  Widget myStreamBuilder({required String status}) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('complaints')
          .where("status", isEqualTo: status)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return myDisplayRow(
              name: data['username'],
              email: data['email'],
              date: data['date'],
              longi: data['longitude'],
              lati: data['latitude'],
              documentId: document.id,
              status: data['status'],
            );
          }).toList(),
        );
      },
    );
  }

  Widget myDisplayRow({
    required String name,
    required String email,
    required String date,
    required String documentId,
    required String longi,
    required String lati,
    required String status,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              "Latitude: $lati",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              "Longitude: $longi",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ]),
          Row(
            children: [
              ElevatedButton(
                onPressed: status == 'Pending'
                    ? () => updateComplaintStatus(documentId)
                    : null,
                child: Text(status == 'Pending' ? 'Complete' : 'Completed'),
              ),
              IconButton(
                  icon: const Icon(Icons.launch),
                  onPressed: () => MapsLauncher.launchCoordinates(
                      double.parse(lati), double.parse(longi))),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const Divider(
            height: 25,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Future<void> updateComplaintStatus(String documentId) async {
    try {
      await _firestore.collection('complaints').doc(documentId).update({
        'status': 'Completed',
      });
      setState(() {});
    } catch (e) {
      // catch block;
    }
  }
}
