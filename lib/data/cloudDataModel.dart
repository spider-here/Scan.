import 'package:firebase_database/firebase_database.dart';

class cloudDataModel {
  String key;
  String downloadUrl;
  String title;

  cloudDataModel(this.key, this.downloadUrl, this.title);

  cloudDataModel.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key.toString(),
        downloadUrl = (snapshot.value as dynamic)["downloadUrl"].toString(),
        title = (snapshot.value as dynamic)["title"].toString();
}
