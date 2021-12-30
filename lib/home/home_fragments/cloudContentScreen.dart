import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_scanner/data/cloudDataModel.dart';
import 'package:pdf_scanner/subActivities/documentViewer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../subActivities/menu.dart';
import '../../subActivities/scan.dart';
import '../../subActivities/search.dart';


class cloudContentScreen extends StatefulWidget{
  String? profilePicture;
  String? email;

  cloudContentScreen({required this.profilePicture, required this.email});
  @override
  State<StatefulWidget> createState() {
    return cloudContentScreenState(profilePicture: profilePicture, email: email);
  }
}


class cloudContentScreenState extends State{

  String? profilePicture;
  String? email;
  cloudContentScreenState({required this.profilePicture, required this.email});

  List<cloudDataModel> cloudData = [];
  User? currentUser = FirebaseAuth.instance.currentUser;
  var dbRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            onTap: ()=>showSearch(context: context, delegate: search(fileNames: getFileNames(), paths: getUrls(), fromCloud: true)),
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
        onPressed: () async {await availableCameras().then((value) => Get.to(()=>scan(cameras: value,),
            transition: Transition.rightToLeft));},
        backgroundColor: Colors.red,
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text("PDF Scanner", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 25.0,),),
      //   actions: [
      //     IconButton(onPressed: (){}, icon: Icon(Icons.credit_card_rounded, color: Colors.black87,), splashRadius: 25.0,),
      //     IconButton(onPressed: (){Get.to(search(), fullscreenDialog: true,transition: Transition.rightToLeftWithFade,);}, icon: Icon(Icons.search_rounded, color: Colors.black87,), splashRadius: 25.0,),
      //     IconButton(onPressed: (){Get.to(menu(), fullscreenDialog: true,transition: Transition.rightToLeftWithFade,);}, icon: Icon(Icons.menu_rounded, color: Colors.black87,), splashRadius: 25.0,),
      //   ],
      // ),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("All(" + cloudData.length.toString() + ")", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)),
                        Padding(padding: EdgeInsets.only(top: 20.0),),
                        cloudData.length > 0 ? ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cloudData.length,
                            itemBuilder: (BuildContext context, int index){
                              return InkWell(
                                onTap: ()=>Get.to(()=>
                                    documentViewer(documentName: cloudData[index].title,
                                        path: cloudData[index].downloadUrl, fromCloud: true)),
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
                                        child: SfPdfViewer.network(cloudData[index].downloadUrl,
                                          canShowScrollHead: false,
                                          canShowScrollStatus: false,
                                          canShowPaginationDialog: false,
                                          canShowPasswordDialog: false,),
                                      ),
                                      Padding(padding: EdgeInsets.only(right: 10.0),),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width/1.8,
                                        child: Text(cloudData[index].title, style: TextStyle(
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
      ),
    ));
  }

  List<String> getFileNames(){
    List<String> fileNames = [];
    cloudData.forEach((element) {
      fileNames.add(element.title);
    });
    return fileNames;
  }

  List<String> getUrls(){
    List<String> urls = [];
    cloudData.forEach((element) {
      urls.add(element.downloadUrl);
    });
    return urls;
  }

  @override
  void initState() {
    super.initState();
    dbRef.child(currentUser!.uid).onChildAdded.listen((event) {
      setState(() {
        cloudData.add(cloudDataModel.fromSnapshot(event.snapshot));
      });
    });
    dbRef.child(currentUser!.uid).onChildChanged.listen((event) {
      var oldEntry = cloudData.singleWhere((element) => element.key == event.snapshot.key);

      setState(() {
        cloudData[cloudData.indexOf(oldEntry)]= cloudDataModel.fromSnapshot(event.snapshot);
      });
    });

  }
}