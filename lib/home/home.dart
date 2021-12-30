
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_fragments/cloudContentScreen.dart';
import 'home_fragments/localContentScreen.dart';

class home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return homeState();
  }
}

class homeState extends State{

  int _navIndex = 0;
  PageController _pageController = new PageController(initialPage: 0);
  User? currentUser = FirebaseAuth.instance.currentUser;

  getprofilePicture(){
    String? profilePicture = FirebaseAuth.instance.currentUser!.photoURL;
    if(profilePicture!=null){
      return profilePicture;
    }
    else{
      return "";
    }
  }

  getEmail(){
    String? email = FirebaseAuth.instance.currentUser!.email;
    if(email!=null){
      return email;
    }
    else{
      return "";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
      elevation: 10.0,
      backgroundColor: Colors.white,
      currentIndex: _navIndex,
      showSelectedLabels: true,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.black87,
      selectedFontSize: 12.0,
      unselectedFontSize: 10.0,
      selectedIconTheme: IconThemeData(color: Colors.red, size: 25.0),
      unselectedIconTheme: IconThemeData(color: Colors.black87, size: 20.0),
      onTap: (change){setState((){_navIndex=change;_pageController.jumpToPage(change);});},
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.file_copy_outlined,
              // color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.file_copy_rounded,
              // color: Theme.of(context).primaryColor,
            ),
            label: "In Device",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.cloud_outlined,
                // color: Colors.grey,
              ),
              activeIcon: Icon(
                Icons.cloud_rounded,
                // color: Theme.of(context).primaryColor,
              ),
              label: "On Cloud"),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [localContentScreen(profilePicture: getprofilePicture(), email: getEmail()),
          cloudContentScreen(profilePicture: getprofilePicture(), email: getEmail()),],
      )
    );
  }
}