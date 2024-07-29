import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'pages/TakePicture.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  runApp(
    MaterialApp(
      theme: ThemeData( // Primary color
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF4169E1), brightness: Brightness.light),
        appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF4169E1),
            titleTextStyle: TextStyle(fontSize: 22),
            centerTitle: true,
          ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0x664169E1), brightness: Brightness.dark),
        appBarTheme: AppBarTheme(
            backgroundColor: Color(0x664169E1),
            titleTextStyle: TextStyle(fontSize: 22),
            centerTitle: true,
          ),
      ),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

