import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'documentViewer.dart';

class search extends SearchDelegate {

  List<String> fileNames = [];
  List<String> paths = [];
  bool fromCloud;


  search({required this.fileNames, required this.paths, required this.fromCloud});


  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black87,), onPressed: () => Navigator.pop(context));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query != null && fileNames.contains(query.toLowerCase())) {
      return InkWell(
        onTap: ()=>{Get.off(()=>documentViewer(documentName: query, path: paths[fileNames.indexOf(query)], fromCloud: fromCloud,))},
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
          elevation: 4.0,
          color: Colors.white,
          margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: Row(
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 1.0, color: Colors.grey)),
                  child: Icon(Icons.file_copy_rounded),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child:Text(query,style:
                  TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else if (query == "") {
      return Text("");
    } else {
      return ListTile(
        title: Text("No results found"),
        onTap: () {},
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
        itemCount: fileNames.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: ()=>Get.off(documentViewer(documentName: fileNames[index], path: paths[index], fromCloud: fromCloud,)),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
              ),
            elevation: 4.0,
            color: Colors.white,
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(width: 1.0, color: Colors.grey)),
                    child: Icon(Icons.file_copy_rounded),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child:Text(fileNames[index],style:
                    TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  )
                ],
              ),
            ),
            ),
          );
        });
  }
}
