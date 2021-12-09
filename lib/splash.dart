import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class splash extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
            splash: Text("scan.", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 50.0,)),
            nextScreen: home(),
        splashTransition: SplashTransition.decoratedBoxTransition,
          ),
    );
  }
}