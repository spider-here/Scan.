
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../home/home.dart';
import 'pdfSuccess.dart';

class pdf extends StatefulWidget{
  List<File> scannedFiles;
  bool fromGallery;
  pdf({required this.scannedFiles, required this.fromGallery});

  @override
  State<StatefulWidget> createState() {
    return pdfState(scannedFiles: scannedFiles, fromGallery: fromGallery);
  }
}

class pdfState extends State{
  List<File> scannedFiles = [];
  bool fromGallery;
  pdfState({required this.scannedFiles, required this.fromGallery});
  final pdf = pw.Document;
  String documentName = DateTime.now().toString();
  ImagePicker galleryPicker = new ImagePicker();
  XFile? galleryImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
                color: Colors.black87
            ),
            leading: IconButton(icon: Icon(Icons.arrow_back_rounded, color: Colors.black87,),
            onPressed: fromGallery?()=>Get.offAll(()=>home()):()=>Get.back()),
            title: Text("Scanned Files", style: TextStyle(color: Colors.black87)),
            actions: [TextButton.icon(onPressed: ()=>onTapCreatePdf(),
              label: Text("Create PDF", style: TextStyle(color: Colors.red),),
              icon: Icon(Icons.picture_as_pdf_rounded, color: Colors.red,),),],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){ fromGallery?pickFromGallery():Get.back();},
        child: Icon(Icons.add_rounded, color: Colors.white,),
        backgroundColor: Colors.red,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: scannedFiles.length,
            itemBuilder: (_, index){return Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey),
              ),
              child: Image.file(scannedFiles[index]),
            );}),
      ),
    );
  }

  onTapCreatePdf() {
    TextEditingController fileNameController = new TextEditingController();
    Get.defaultDialog(title: "",
        content: TextField(controller: fileNameController,
        decoration: InputDecoration(
          labelText: "Enter Filename"
        ),),
    onConfirm: () async {
      if(fileNameController.text.length>0){
        documentName = fileNameController.text;
        await createPdf(pdf, documentName);
      }
      else{
        Get.snackbar("No Filename!", "Please enter a file name first.",
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red,
        colorText: Colors.white);
      }
    },
    textConfirm: "Done",
    confirmTextColor: Colors.white,
    contentPadding: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 40.0),);
  }

  createPdf(pdf, documentName) async {
    final pdf = pw.Document();
    for(var file in scannedFiles) {
      final image = PdfImage.file(
        pdf.document,
        bytes: File(file.path).readAsBytesSync(),
      );
      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat(2480, 3508),
        build: (pw.Context context) {
          return pw.Expanded(
              child: pw.Image(pw.ImageProxy(image), fit: pw.BoxFit.fitWidth)
          );
        },
      ));
    }
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final tempDir = await getExternalStorageDirectory();
    String pdfPath = tempDir!.path + "/$documentName" + ".pdf";
    File pdfFile = File(pdfPath);
    print(pdfPath);
    pdfFile.writeAsBytes(await pdf.save()).then((value) {
      Get.offAll(()=>pdfSuccess(pdfPath: pdfPath, documentName: documentName), transition: Transition.rightToLeft);
    });
  }

  pickFromGallery() async {
    galleryImage = await galleryPicker.pickImage(source: ImageSource.gallery);
    if(galleryImage != null){
      _cropImage().whenComplete(() => setState((){}));
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
      scannedFiles.add(croppedFile);
      print("Cropped");
      // setState(() {
      // });
    }
  }

  @override
  void initState() {
    super.initState();
  }
}