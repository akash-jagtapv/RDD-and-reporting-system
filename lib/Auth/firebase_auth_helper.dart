import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return await _auth.currentUser;
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
