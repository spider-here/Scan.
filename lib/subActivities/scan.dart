import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pdf_scanner/subActivities/pdf.dart';

class scan extends StatefulWidget{

  List<CameraDescription> cameras;

  scan({required this.cameras});

  @override
  State<StatefulWidget> createState() {
    return scanState(cameras: cameras);
  }

}

class scanState extends State{

  List<CameraDescription> cameras;
  scanState({required this.cameras});
  late CameraController _cameraController;
  XFile? pictureFile;
  List<File> croppedFiles = [];


  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: pictureFile!.path,
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


  @override
  Widget build(BuildContext context) {
    if(!_cameraController.value.isInitialized){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          title: Text("Scan", style: TextStyle(color: Colors.white))
        ),
      body: Container(
        color: Colors.black87,
        child: Stack(
          children: [
            Align(
              alignment: FractionalOffset.topCenter,
              child: Container(
                padding: EdgeInsets.all(30.0),
                child: CameraPreview(_cameraController),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 30.0),
                child: FloatingActionButton(
                  child: Icon(Icons.document_scanner_rounded, color: Colors.white,),
                  onPressed: () async {
                    pictureFile = await _cameraController.takePicture();
                    setState((){});
                    if(pictureFile!= null){
                      print("Captured");
                      _cropImage().then((value) => Get.to(()=>pdf(scannedFiles: croppedFiles, fromGallery: false,)));
                    }
                  },
                  backgroundColor: Colors.red,
                ),
              )
            ),
          ],
        )
      ));
  }

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      cameras[0], ResolutionPreset.max
    );
    _cameraController.initialize().then((value) {
      if(!mounted){
        return;
      }
      setState((){});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

}