import 'package:flutter/material.dart';

const scaffoldBackground = Color(0xFFF4F4F4);
const cardColor = Color(0xFFFFFFFF);
const secondaryColor = Color(0xFFFFA971);
const bottomBarColor = Color(0xFF22252D);
const accentColor = Color(0xFFFB6502);

//Neutral
const black = Color(0xFF000000);
const white = Color(0xFFFFFFFF);


BoxDecoration bDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 8),
    ),
  ],
);