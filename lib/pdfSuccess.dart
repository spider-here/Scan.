import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';

class pdfSuccess extends StatefulWidget{
  String pdfPath;
  String documentName;
  pdfSuccess({required this.pdfPath, required this.documentName});
  @override
  State<StatefulWidget> createState() {
    return pdfSuccessState(pdfPath: pdfPath, documentName: documentName);
  }
  
}


class pdfSuccessState extends State{
  String pdfPath;
  String documentName;
  pdfSuccessState({required this.pdfPath, required this.documentName});
  FirebaseStorage stoRef = FirebaseStorage.instance;
  bool showProgressBar = false;
  User? currentUser = FirebaseAuth.instance.currentUser;

  addToFireStorage() async {
    setState((){
      showProgressBar = true;
    });
    try{
      await stoRef.ref(currentUser!.email).child("$documentName").putFile(File(pdfPath));
      setState((){
        showProgressBar = false;
        Get.snackbar("Backup","File Uploaded to Cloud", colorText: Colors.white,
            backgroundColor: Colors.black, snackPosition: SnackPosition.BOTTOM);
        Get.off(home());
      });
    }
    catch(e){
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Icon(Icons.assignment_turned_in_rounded, color: Colors.red, size: MediaQuery.of(context).size.width/2.2,),
                Text("PDF Generated Successfully", textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0)),
                Padding(padding: EdgeInsets.all(10.0)),
                Text("File Path: $pdfPath", textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey,)),
                Spacer(),
                Visibility(child: Padding(padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(),),
                visible: showProgressBar),
                Visibility(child: ElevatedButton.icon(onPressed: (){addToFireStorage();},
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                        )
                    ),
                    icon: Icon(Icons.backup_rounded, color: Colors.white,),
                    label: Text("Backup to Cloud", style: TextStyle(color: Colors.white))),
                visible: showProgressBar==true?false:true),
                Visibility(
                  child: TextButton.icon(onPressed: (){Get.off(()=>home());},
                      icon: Icon(Icons.arrow_back_rounded, color: Colors.red,),
                      label: Text("Back to Main", style: TextStyle(color: Colors.red))),
                  visible: showProgressBar==true?false:true,
                ),
                Padding(padding: EdgeInsets.all(20.0))
              ],
            ),
      )
      ),
    );
  }

}