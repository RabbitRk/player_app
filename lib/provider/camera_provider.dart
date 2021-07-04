import 'package:flutter/material.dart';

class CameraModel extends ChangeNotifier {

  bool isDetected = false;

  void getStatus(bool detected) async {
    isDetected = detected;
    notifyListeners();
  }
}