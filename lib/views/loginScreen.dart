// ignore_for_file: unused_local_variable, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../Services/showErrorDilog.dart';
import 'forgetPassword.dart';
import 'signUpScreen.dart';
import 'storepage/home_page.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
                  controller: loginEmailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    enabledBorder: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  )),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                  controller: loginPasswordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    enabledBorder: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: Icon(Icons.visibility),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  var loginEmail = loginEmailController.text.trim();
                  var loginPassword = loginPasswordController.text.trim();
                  try {
                    final User? firebaseUser = (await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: loginEmail, password: loginPassword))
                        .user;
                    if (firebaseUser != null) {
                      Get.to(() => MyHomePage());
                    }
                  } on FirebaseAuthException catch (e) {
                    ShowErrorDilog(context, e.toString());
                  }
                },
                child: Text("Login")),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => ForgetPasssword());
              },
              child: Container(
                  child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("Forgot Password"),
                ),
              )),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                    onTap: () {
                      Get.to(() => SignUpScreen());
                    },
                    child: Text("I Don't have a account SignUp")),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
