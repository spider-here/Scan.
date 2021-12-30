import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_scanner/access/login.dart';

import '../home/home.dart';

class splash extends StatelessWidget{

  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
            splash: Text("PDF Scanner", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40.0,)),
            nextScreen: currentUser != null?home():login(),
        splashTransition: SplashTransition.decoratedBoxTransition,
        customTween: DecorationTween(
            end: BoxDecoration(color: Colors.red),
            begin: BoxDecoration(color: Colors.white)),
        animationDuration: Duration(milliseconds: 600),
        duration: 1000,
        ),
    );
  }
}