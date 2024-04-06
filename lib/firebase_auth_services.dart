import "package:firebase_auth/firebase_auth.dart";
import 'package:sir_syed_case/toast.dart';
//import 'package:sir_syed_case/data.dart';

class FirebaseAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> signupWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'Email Address Already in Use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signinWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid Email or Password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  // Future<Student?> SignUpStudent(
  //     String email, String password) async {
  //   try {
  //     UserCredential credential = await auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     return credential.user;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'email-already-in-use') {
  //       showToast(message: 'The email address is already in use.');
  //     } else {
  //       showToast(message: 'An error occurred: ${e.code}');
  //     }
  //   }
  //   return null;
  // }

  // Future<User?> signinWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     UserCredential credential = await auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     return credential.user;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found' || e.code == 'wrong-password') {
  //       showToast(message: 'Invalid email or password.');
  //     } else {
  //       showToast(message: 'An error occurred: ${e.code}');
  //     }
  //   }
  //   return null;
  // }
}
