import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SizeNotifier extends ChangeNotifier{
  double val = 0.0;

  double get value => val;

  void updateSize(double i)
  {
    val = i;
    notifyListeners();
  }
}


