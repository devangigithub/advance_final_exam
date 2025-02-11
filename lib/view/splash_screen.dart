import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Get.off(HomePage());
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network("https://media.istockphoto.com/id/971654072/vector/red-call-icon.jpg?s=612x612&w=0&k=20&c=bwlNm0pnNs98evZv4x8N3Cq3XQAWIKLEzJPmQpbMgWY=",height: 100,width: 100,),
          SizedBox(height: 30,),
          Text("Contact App",style: TextStyle(color: Colors.black,fontSize: 30,fontStyle: FontStyle.italic,fontWeight: FontWeight.w700),),
        ],
      )),
    );
  }
}