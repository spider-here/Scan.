import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

import '../home/home.dart';

class login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return loginState();
  }
}

class loginState extends State {

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential).whenComplete(() => Get.off(()=>home()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("PDF Scanner", style: TextStyle(color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0,)),
                ),
                Spacer(),
                Card(
                  color: Colors.white,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.all(20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height/2.5,
                    width: MediaQuery.of(context).size.width/1.5,
                    padding: EdgeInsets.all(30.0),
                    margin: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          width: 1.0,
                          color: Colors.grey
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text("Login", style: TextStyle(color: Colors.grey, fontSize: 20.0,),),
                        Spacer(),
                        ElevatedButton(onPressed: (){signInWithGoogle();}, child: Text("Sign in with Google"),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )
                              )
                          ),),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        )
    );
  }

  @override
  void initState() {
    super.initState();
  }
}