import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore storage = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
 User? get user => auth.currentUser;

  Future loginUser({required String email, required String password}) async {
    return await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future registerUser({required String email, required String password}) async {
    return await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<User?> getUser() async {
    try {
      final user = auth.currentUser;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    await auth.signOut();
  }

  Future googleSignOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  Future sendPasswordResetLink({required String email}) async {
    await auth.sendPasswordResetEmail(email: email);
  }
}
