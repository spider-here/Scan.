import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_scanner/subActivities/documentViewer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../subActivities/menu.dart';
import '../../subActivities/pdf.dart';
import '../../subActivities/scan.dart';
import '../../subActivities/search.dart';


class localContentScreen extends StatefulWidget{
  String? profilePicture;
  String? email;
  localContentScreen({required this.profilePicture, required this.email});
  @override
  State<StatefulWidget> createState() {
    return localContentScreenState(profilePicture: profilePicture, email: email);
  }

}

class localContentScreenState extends State{

  List<String> fileNames = ["Filename here..","Filename here..","Filename here..","Filename here..","Filename here..",];
  List<String> fileThumbnail = ["abc","abc","abc","abc","abc"];
  String? profilePicture;
  String? email;
  ImagePicker galleryPicker = new ImagePicker();
  XFile? galleryImage;
  List<File> croppedFiles = [];
  var dir = Directory("/storage/emulated/0/Android/data/com.spider.pdf_scanner/files/");
  List<FileSystemEntity> _files = [];

  localContentScreenState({required this.profilePicture, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: InkWell(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey.shade200,
            ),
            height: 30.0,
            child: Row(
              children: [
                Padding(padding: EdgeInsets.only(right: 10.0),),
                Icon(Icons.search_rounded, color: Colors.black87,),
                Padding(padding: EdgeInsets.only(right: 10.0),),
                Text("Search",style: TextStyle(color: Colors.grey, fontSize: 14.0)),
              ],
            ),
          ),
          onTap: ()=>showSearch(context: context, delegate: search(fileNames: getFileNames(), paths: getPaths(), fromCloud: false))
        ),
        actions: [
          // IconButton(onPressed: (){}, icon: Icon(Icons.cloud_rounded, color: Colors.red,), splashRadius: 25.0,),
          // IconButton(onPressed: (){}, icon: Icon(Icons.credit_card_rounded, color: Colors.red,), splashRadius: 25.0,),
          IconButton(onPressed: (){Get.to(()=>menu(profilePicture: profilePicture, email: email,),
              fullscreenDialog: true, transition: Transition.rightToLeft);},
            icon: Icon(Icons.menu_rounded, color: Colors.red,), splashRadius: 25.0,),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.document_scanner_rounded, color: Colors.white,),
        onPressed: () async {await availableCameras().then((value) => Get.to(()=>scan(cameras: value,), transition: Transition.rightToLeft));},
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(top: 30.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton.icon(onPressed: () async {await availableCameras().then((value) => Get.to(scan(cameras: value,),
          transition: Transition.rightToLeft));},
                      icon: Icon(Icons.document_scanner_rounded),
                        label: Text("Scan", style: TextStyle(color: Colors.black87)),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1,
                                      color: Colors.grey.shade200
                                  ),
                                  borderRadius: BorderRadius.circular(20.0)
                              )
                          )
                      ),),
                    Padding(padding: EdgeInsets.only(right: 50.0),),
                    TextButton.icon(onPressed: ()=>pickFromGallery(), icon: Icon(Icons.insert_photo_rounded),
                        label: Text("Import", style: TextStyle(color: Colors.black87)),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Colors.grey.shade200
                          ),
                          borderRadius: BorderRadius.circular(20.0)
                        )
                      )
                    ),),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 15.0),),
                Container(
                    width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                    color: Colors.white
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Recent Docs", style: TextStyle(color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.bold)),
                      fileNames.length> 0 ?
                      ListView.builder(
                        physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _files.length,
                            itemBuilder: (BuildContext context, int index){
                              return InkWell(
                                onTap: ()=>Get.to(()=>
                                    documentViewer(documentName: _files.elementAt(index).path.split("/").last,
                                        path: _files[index].path, fromCloud: false)),
                                child: Container(
                                  margin: EdgeInsets.only(top: 16.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 80.0,
                                        width: 80.0,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.0,
                                                color: Colors.grey
                                            )
                                        ),
                                        child: SfPdfViewer.file(File(_files[index].path),
                                          canShowScrollHead: false,
                                          canShowScrollStatus: false,
                                          canShowPaginationDialog: false,
                                          canShowPasswordDialog: false,
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(right: 10.0),),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width/1.8,
                                        child: Text(_files.elementAt(index).path.split("/").last, style: TextStyle(
                                            overflow: TextOverflow.ellipsis
                                        ),),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }):
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/2,
                        child: Center(
                          child: Container(
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.file_copy_rounded, color: Colors.grey, size: 50.0),
                                Padding(padding: EdgeInsets.only(top: 10.0),),
                                Text("No Recent Files", style: TextStyle(color: Colors.grey),)
                              ],
                            )
                          )
                        ),
                      ),
                    ],
                  )
                ),
              ],

            ),
          )
      ),
    );
  }

  pickFromGallery() async {
    galleryImage = await galleryPicker.pickImage(source: ImageSource.gallery);
    if(galleryImage != null){
      _cropImage().then((value) => Get.off(()=>pdf(scannedFiles: croppedFiles, fromGallery: true,)));
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

  getFiles(){
    _files = dir.listSync(recursive: true, followLinks: false);
    setState((){});
  }

  List<String> getFileNames(){
    List<String> fileNames = [];
    _files.forEach((element) {
      fileNames.add(element.path.split("/").last);
    });
    return fileNames;
  }

  List<String> getPaths(){
    List<String> paths = [];
    _files.forEach((element) {
      paths.add(element.path);
    });
    return paths;
  }

  @override
  void initState() {
    super.initState();
    getFiles();
  }
}
