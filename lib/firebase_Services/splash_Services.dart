import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial_app/UI/HomePage.dart';
import 'package:firebase_tutorial_app/UI/auth/SignIn_Screen.dart';
import 'package:flutter/material.dart';

class SplashServices{
  void isLogin(BuildContext context){
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    if(user != null){
      // user is login
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return HomePage();
        },));
      });
    }else{
      // user is not login
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return SignInScreen();
        },));
      });
    }
  }
}

