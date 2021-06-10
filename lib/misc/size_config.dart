import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SizeConfig {
  static late double _screenWidth;
  static late double _screenHeight;

  static double? screenWidth_;
  static double? screenHeight_;

  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static double? textMultiplier;
  static double? imageSizeMultiplier;
  static late double heightMultiplier;
  static late bool isPortrait;
  static bool? isTab;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenHeight = constraints.maxHeight;
      _screenWidth = constraints.maxWidth;

      screenHeight_ = constraints.maxHeight;
      screenWidth_ = constraints.maxWidth;

      isPortrait = true;

      //isTab finder
      if (_screenWidth > 600) {
        isTab = true;
      } else {
        isTab = false;
      }

    } else {
      _screenHeight = constraints.maxWidth;
      _screenWidth = constraints.maxHeight;

      screenHeight_ = constraints.maxHeight;
      screenWidth_ = constraints.maxWidth;

      isPortrait = false;

      // isTab finder
      if (_screenWidth > 600) {
        isTab = true;
      } else {
        isTab = false;
      }

    }

    _blockSizeHorizontal  = _screenWidth / 100;
    _blockSizeVertical    = _screenHeight / 100;

    textMultiplier        = _blockSizeVertical;
    imageSizeMultiplier   = _blockSizeHorizontal;
    heightMultiplier      = _blockSizeVertical;

    // print("TextMultiplier..." + textMultiplier.toString());
    // print("ImageSizeMultiplier..." + imageSizeMultiplier.toString());
    // print("HeightMultiplier..." + heightMultiplier.toString());

    // print("ScreenHeight..." + _screenHeight.toString());
    // print("ScreenWidth..." + _screenWidth.toString());
  }
}
