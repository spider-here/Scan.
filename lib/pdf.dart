
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'pdfSuccess.dart';

class pdf extends StatefulWidget{
  List<File> scannedFiles;
  pdf({required this.scannedFiles});

  @override
  State<StatefulWidget> createState() {
    return pdfState(scannedFiles: scannedFiles);
  }
}

class pdfState extends State{
  List<File> scannedFiles = [];
  pdfState({required this.scannedFiles});
  final pdf = pw.Document;
  String documentName = DateTime.now().toString();

  createPdf(pdf) async {
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
    final tempDir = await getExternalStorageDirectory();
    String pdfPath = tempDir!.path + "/$documentName" + ".pdf";
    File pdfFile = File(pdfPath);
    print(pdfPath);
    pdfFile.writeAsBytes(await pdf.save()).then((value) {
      Get.offAll(()=>pdfSuccess(pdfPath: pdfPath, documentName: documentName), transition: Transition.rightToLeft);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
                color: Colors.black
            ),
            title: Text("Scanned Files", style: TextStyle(color: Colors.black)),
            actions: [TextButton.icon(onPressed: () async {await createPdf(pdf);},
              label: Text("Create PDF", style: TextStyle(color: Colors.red),),
              icon: Icon(Icons.picture_as_pdf_rounded, color: Colors.red,),),],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){Get.back();},
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

  @override
  void initState() {
    super.initState();
  }
}