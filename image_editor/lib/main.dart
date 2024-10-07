import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_editor/screen/home_screen.dart';

void main() {
  debugRepaintRainbowEnabled = true;
  runApp(MaterialApp(home: HomeScreen()));
}
