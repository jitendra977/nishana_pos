import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      style: const TextStyle(fontSize: 18.0),
    );
  }
}

class UserDetailPage extends StatefulWidget {
  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  late DocumentReference userDocRef;
  late Map<String, dynamic> userData = {
    'userId': '',
    'userName': '',
    'userEmail': '',
    'userPhone': '',
  };

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userDocRef = firestore.collection('users').doc(auth.currentUser!.uid);
    getUserData();
  }

  void getUserData() async {
    DocumentSnapshot snapshot = await userDocRef.get();
    userData = snapshot.data() as Map<String, dynamic>;
    setState(() {
      _nameController.text = userData['userName'];
      _emailController.text = userData['userEmail'];
      _phoneController.text = userData['userPhone'];
    });
  }

  void updateUser() async {
    userData['userName'] = _nameController.text;
    userData['userEmail'] = _emailController.text;
    userData['userPhone'] = _phoneController.text;
    try {
      await userDocRef.update(userData);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data updated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating user data')));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' ${userData['userName'] ?? ''}'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/logo/logo.png"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User ID: ${userData['userId'] ?? ''}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _nameController,
              labelText: 'Name',
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _phoneController,
              labelText: 'Phone',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => updateUser(),
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
