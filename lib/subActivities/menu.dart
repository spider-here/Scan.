
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_scanner/subActivities/pdf.dart';
import 'package:pdf_scanner/access/splash.dart';
import 'package:share_plus/share_plus.dart';

class menu extends StatelessWidget{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  List menuIcons = [Icons.insert_photo_rounded, Icons.share_rounded, Icons.star_rate_rounded, Icons.privacy_tip_rounded,];
  List menuTitles = ["Import from Gallery", "Share this App", "Rate this App", "Privacy Policy",];

  String? profilePicture;
  String? email;
  String appUrl = "https://www.google.com/";
  ImagePicker galleryPicker = new ImagePicker();
  XFile? galleryImage;
  List<File> croppedFiles = [];

  menu({required this.profilePicture, required this.email});

  Future<void> signOutFromGoogle() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Transform.rotate(
          angle: 90 * math.pi / 180,
          child: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: Colors.red,
            ),
            onPressed: (){Get.back();},
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 20.0),
        child: Stack(
          children: [
            Align(alignment: FractionalOffset.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(20.0),
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.0,
                        color: Colors.red,
                      ),
                      image: DecorationImage(
                          image: NetworkImage(profilePicture!),
                          fit: BoxFit.fill
                      )
                  ),
                ),
                Text(email!, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16.0)),
              ],
            ),),
            Align(
              alignment: FractionalOffset.center,
              child: Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: ListView.builder(itemBuilder: (BuildContext context, int index){
                return Card(
                    color: Colors.white,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0,),
                    child: Container(
                      margin: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            width: 1.0,
                            color: Colors.grey.shade200
                        ),
                      ),
                      child: ListTile(
                        onTap: (){optionPressed(index);},
                        leading: Icon(menuIcons[index], color: Colors.black87,),
                        title: Text(menuTitles[index]),
                        dense: true,
                      ),
                    ));
              },
                physics: BouncingScrollPhysics(),
                itemCount: menuTitles.length,
              shrinkWrap: true,),)
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Card(
                  color: Colors.red,
                  elevation: 4.0,
                  shadowColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    margin: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          width: 1.0,
                          color: Colors.white
                      ),
                    ),
                    child: ElevatedButton.icon(
                        onPressed: (){signOutFromGoogle().whenComplete(() => Get.offAll(()=>splash()));},
                        icon: Icon(Icons.logout_rounded, color: Colors.white),
                        label: Text("Logout", style: TextStyle(color: Colors.white)))
                    // ListTile(
                    //   onTap: (){signOutFromGoogle().whenComplete(() => Get.offAll(()=>splash()));},
                    //   dense: true,
                    //   leading: Icon(Icons.logout_rounded, color: Colors.white),
                    //   title: Text("Logout", style: TextStyle(color: Colors.white)),
                    // ),
                  )),
            ),
          ],
        )
      )

    );
  }

  optionPressed(int index){
    switch(index){
      case 0: {
        pickFromGallery();
      }
      break;
      case 1: {
        Share.share("Hey check out this cool app!\n $appUrl");
      }
      break;
      case 2: {}
      break;
      case 3: {}
      break;
    }
  }

  pickFromGallery() async {
    galleryImage = await galleryPicker.pickImage(source: ImageSource.gallery);
    if(galleryImage != null){
      _cropImage().then((value) => Get.to(()=>pdf(scannedFiles: croppedFiles, fromGallery: true,)));
    }
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: galleryImage!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Colors.black87,
            backgroundColor: Colors.black87,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.red,
            statusBarColor: Colors.black87,
            // hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      // scannedFile = croppedFile;
      croppedFiles.add(croppedFile);
      print("Cropped");
      // setState(() {
      // });
    }
  }

}