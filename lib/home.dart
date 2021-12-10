
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pdf_scanner/search.dart';

import 'documentViewer.dart';
import 'menu.dart';

class home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.document_scanner_rounded, color: Colors.white,),
        onPressed: () {},
        backgroundColor: Colors.red,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("PDF Scanner", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 25.0,),),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.credit_card_rounded, color: Colors.black87,), splashRadius: 25.0,),
          IconButton(onPressed: (){Get.to(search(), fullscreenDialog: true,transition: Transition.rightToLeftWithFade,);}, icon: Icon(Icons.search_rounded, color: Colors.black87,), splashRadius: 25.0,),
          IconButton(onPressed: (){Get.to(menu(), fullscreenDialog: true,transition: Transition.rightToLeftWithFade,);}, icon: Icon(Icons.menu_rounded, color: Colors.black87,), splashRadius: 25.0,),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Stack(
            children: [
              Align(
                  alignment: FractionalOffset.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: new StaggeredGridView.countBuilder(
                      physics: BouncingScrollPhysics(),
                      crossAxisCount: 4,
                      itemCount: 8,
                      itemBuilder: (BuildContext context, int index) => new InkWell(
                        onTap: (){Get.to(documentViewer(), fullscreenDialog: true, transition: Transition.downToUp);},
                    child:Card(
                          color: Colors.white,
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          margin: EdgeInsets.zero,
                        child: Container(
                          margin: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              width: 1.0,
                              color: Colors.grey
                            ),
                            image: DecorationImage(
                              image: NetworkImage("https://i0.wp.com/www.cuppacocoa.com/wp-content/uploads/2018/10/Free-dotted-paper-for-preschooler-kindergarten-first-second-grade.png?w=526"),
                              fit: BoxFit.cover
                            )
                          ),
                          child: Stack(
                            children: [Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      width: 1.0,
                                      color: Colors.grey
                                  ),
                                color: Colors.white),
                                child: ListTile(
                                  tileColor: Colors.white,
                                  dense: true,
                                  trailing: Text("25/7", style: TextStyle(fontSize: 10.0, color: Colors.grey),),
                                  title: Text("File Name", style: TextStyle(fontSize: 12.0),),
                                ),
                              ),
                            )]
                          ),
                        ),
                      ),
                      ),
                      staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(2, index.isEven ? 3 : 4),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      padding: EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 100.0),
                    )
                  )
              ),
              Align(
                alignment: FractionalOffset.topCenter,
                child: Card(color: Colors.black,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(15.0),
                    child:Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          TextButton(onPressed: (){}, style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.red),
                          ),child: Column(
                            children: [Icon(Icons.file_present_rounded, color: Colors.white, size: 30.0,),
                              Text("Docs", style: TextStyle(
                                  color: Colors.white
                              ),),
                            ],
                          ),),
                          Spacer(),
                          TextButton(onPressed: (){}, style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.red),
                          ),child: Column(
                            children: [Icon(Icons.quick_contacts_mail_rounded, color: Colors.white, size: 30.0,),
                              Text("ID Card", style: TextStyle(
                                  color: Colors.white
                              ),),
                            ],
                          ),),
                          Spacer(),
                          TextButton(onPressed: (){}, style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.red),
                          ),child: Column(
                            children: [Icon(Icons.menu_book_rounded, color: Colors.white, size: 30.0,),
                              Text("Book", style: TextStyle(
                                  color: Colors.white
                              ),),
                            ],
                          ),),
                          Spacer(),
                          TextButton(onPressed: (){}, style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.red),
                          ),child: Column(
                            children: [Icon(Icons.perm_contact_cal_rounded, color: Colors.white, size: 30.0,),
                              Text("ID Photo", style: TextStyle(
                                  color: Colors.white
                              ),),
                            ],
                          ),),
                          Spacer(),

                        ],
                      ),
                    ) ),
              ),

            ]

          ),
        )
      ),
    );
  }

}