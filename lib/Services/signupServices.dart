import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseapp/views/loginScreen.dart';
import 'package:get/get.dart';

signupUser(
  String userName,
  String userPhone,
  String userEmail,
  String userPassword,
) async {
  User? userid = FirebaseAuth.instance.currentUser;

  try {
    await FirebaseFirestore.instance.collection("users").doc(userid!.uid).set({
      'userName': userName,
      'userPhone': userPhone,
      'userEmail': userEmail,
      'userPassword': userPassword,
      'createdAt': DateTime.now(),
      'userId': userid.uid,
    }).then((value) =>
        {FirebaseAuth.instance.signOut(), Get.to(() => LoginScreen())});
  } on FirebaseAuthException catch (e) {
    print("Error: $e");
  }
}
