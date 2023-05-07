import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:nishanapos/Services/Providers/CartProviders/GrandTotalProvider.dart';
import 'package:nishanapos/provider/providers/example_1Provider.dart';
import 'package:provider/provider.dart';
import 'Services/Providers/Category_selector.dart';
import 'views/loginScreen.dart';
import 'views/storepage/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GrandTotalProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ExampleOneProvider()),
      ],
      child: GetMaterialApp(
        title: 'Nishana POS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: user != null ? MyHomePage() : LoginScreen(),
      ),
    );
  }
}
