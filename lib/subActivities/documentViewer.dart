import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class documentViewer extends StatelessWidget{
  String documentName, path;
  bool fromCloud;


  documentViewer({required this.documentName, required this.path, required this.fromCloud});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$documentName", style: TextStyle(
          color: Colors.red
        ),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black87
        ),
      ),
      body:fromCloud?SfPdfViewer.network(path):SfPdfViewer.file(File(path))
        // Stack(
        //   children:[
        //     Align(
        //       alignment: FractionalOffset.topCenter,
        //       child: Card(
        //         color: Colors.white,
        //         elevation: 10.0,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10.0),
        //         ),
        //         margin: EdgeInsets.zero,
        //         child: Container(
        //           width: MediaQuery.of(context).size.width/1.2,
        //           height: MediaQuery.of(context).size.height/1.4,
        //           margin: EdgeInsets.all(2.0),
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(10.0),
        //               border: Border.all(
        //                   width: 1.0,
        //                   color: Colors.grey
        //               ),
        //               image: DecorationImage(
        //                   image: NetworkImage("https://i0.wp.com/www.cuppacocoa.com/wp-content/uploads/2018/10/Free-dotted-paper-for-preschooler-kindergarten-first-second-grade.png?w=526"),
        //                   fit: BoxFit.cover
        //               )
        //           ),
        //         ),
        //       ),
        //     ),
        //   Align(
        //     alignment: FractionalOffset.bottomCenter,
        //     child: Padding(
        //       padding: EdgeInsets.only(bottom: 50.0),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           FloatingActionButton(onPressed: (){}, child: Icon(Icons.share_rounded), mini: true,
        //             backgroundColor: Colors.black87,),
        //           Padding(
        //             padding: EdgeInsets.all(10.0),
        //           ),
        //           FloatingActionButton(onPressed: (){}, child: Icon(Icons.delete_rounded), mini: true,
        //             backgroundColor: Colors.black87,),
        //         ],
        //       ),
        //     )
        //   ),
        //   ]
        // ),
      // ),
    );
  }

}