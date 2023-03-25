// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseapp/Services/showErrorDilog.dart';
import 'package:firebaseapp/views/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ForgetPasssword extends StatelessWidget {
  TextEditingController forgotEmeilController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        actions: [Icon(Icons.more_vert)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              alignment: Alignment.center,
              child: Lottie.asset("assets/38435-register.json"),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                  controller: forgotEmeilController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    enabledBorder: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  var forgotEmail = forgotEmeilController.text.trim();
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: forgotEmail)
                        .then((value) => {
                              print("Reset Password link is send"),
                              Get.off(() => LoginScreen())
                            });
                  } on FirebaseAuthException catch (e) {
                    ShowErrorDilog(context, e.toString());
                  }
                },
                child: Text("Forgot Password")),
          ],
        ),
      ),
    );
  }
}
