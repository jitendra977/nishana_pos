// ignore_for_file: must_be_immutable


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../Services/showErrorDilog.dart';
import '../Services/signupServices.dart';
import 'loginScreen.dart';

class SignUpScreen extends StatelessWidget {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
        actions: [Icon(Icons.more_vert)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              alignment: Alignment.center,
              child: Lottie.asset("assets/38435-register.json"),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    hintText: "User Name",
                    enabledBorder: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_4_outlined),
                  )),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                  controller: userPhoneController,
                  decoration: InputDecoration(
                    hintText: "Phone",
                    enabledBorder: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.call),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                  controller: userEmailController,
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
                  obscureText: true,
                  controller: userPasswordController,
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
                  var userName = userNameController.text.trim();
                  var userPhone = userPhoneController.text.trim();
                  var userEmail = userEmailController.text.trim();
                  var userPassword = userPasswordController.text.trim();

                  try {
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: userEmail, password: userPassword)
                        .then((value) => {
                              signupUser(
                                  userName, userPhone, userEmail, userPassword)
                            });
                  } on FirebaseAuthException catch (e) {
                    ShowErrorDilog(context, e.toString());
                  }
                },
                child: Text("Sign Up")),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => LoginScreen());
              },
              child: Container(
                  child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("Already Have an account Login"),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
