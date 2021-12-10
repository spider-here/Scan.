import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_scanner/splash.dart';

void main() {
  runApp(GetMaterialApp(
    home: splash(),
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),
  ));
}