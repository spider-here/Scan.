import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdf_scanner/splash.dart';

class menu extends StatelessWidget{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  List menuIcons = [Icons.insert_photo_rounded, Icons.credit_card_rounded, Icons.share_rounded, Icons.star_rate_rounded, Icons.privacy_tip_rounded,];
  List menuTitles = ["Import from Gallery", "Remove Adds", "Share this App", "Rate this App", "Privacy Policy",];

  Future<void> signOutFromGoogle() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        leading: Transform.rotate(
          angle: 90 * math.pi / 180,
          child: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: Colors.black,
            ),
            onPressed: (){Get.back();},
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 30.0),
        child: Stack(
          children: [
            Align(
              alignment: FractionalOffset.topCenter,
              child: ListView.builder(itemBuilder: (BuildContext context, int index){
                return Card(
                    color: Colors.white,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(10.0),
                    child: Container(
                      margin: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            width: 1.0,
                            color: Colors.grey
                        ),
                      ),
                      child: ListTile(
                        onTap: (){},
                        leading: Icon(menuIcons[index]),
                        title: Text(menuTitles[index]),
                      ),
                    ));
              },
                physics: BouncingScrollPhysics(),
                itemCount: menuTitles.length,),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Card(
                  color: Colors.red,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
                  child: Container(
                    margin: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          width: 1.0,
                          color: Colors.white
                      ),
                    ),
                    child: ListTile(
                      onTap: (){signOutFromGoogle().whenComplete(() => Get.offAll(()=>splash()));},
                      leading: Icon(Icons.logout_rounded, color: Colors.white),
                      title: Text("Logout", style: TextStyle(color: Colors.white)),
                    ),
                  )),
            ),
          ],
        )
      )

    );
  }



}