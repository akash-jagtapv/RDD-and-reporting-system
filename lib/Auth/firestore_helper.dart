import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  Future addUserDetails(Map<String, dynamic> userData, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userData);
  }

  Future complaint(Map<String, dynamic> data, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('complaints')
        .doc(id)
        .set(data);
  }

  Future updateUserProfile(String id, Map<String, dynamic> userData) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update(userData);
  }

  Future<QuerySnapshot> getUserbyEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("Email", isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> getUserbyId(String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("Id", isEqualTo: uid)
        .get();
  }

  // Future saveMessageToFireStore(
  //     String chatRoomID, String messageId, Map<String, dynamic> messageMap) {
  //   return FirebaseFirestore.instance
  //       .collection('chatroom')
  //       .doc(chatRoomID)
  //       .collection('chat')
  //       .doc(messageId)
  //       .set(messageMap);
  // }

  Future<QuerySnapshot> getUserByUserName(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("Username", isEqualTo: username)
        .get();
  }
}
