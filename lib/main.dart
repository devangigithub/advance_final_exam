
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseminer/view/home_page.dart';
import 'package:firebaseminer/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Contacts App',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      initialRoute: "/",
      getPages: [
        GetPage(
          name: "/",
          page: () => SplashScreen(),
        ),
        GetPage(
          name: "/home_page",
          page: () => HomePage(),
        ),
      ],
    );
  }
}










