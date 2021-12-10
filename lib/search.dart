import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'documentViewer.dart';

class search extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
            onPressed: (){Get.back();},
          ),
        title: TextField(
          decoration: InputDecoration(
              labelText: "Search",
            labelStyle: TextStyle(color: Colors.red)
          ),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: new StaggeredGridView.countBuilder(
            physics: BouncingScrollPhysics(),
            crossAxisCount: 4,
            itemCount: 8,
            itemBuilder: (BuildContext context, int index) => new InkWell(
              onTap: (){Get.to(documentViewer(), fullscreenDialog: true, transition: Transition.downToUp);},
              child: Card(
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
            new StaggeredTile.count(2, index.isEven ? 3 : 2),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            padding: EdgeInsets.all(20.0),
          )
      ),
    );
  }

}