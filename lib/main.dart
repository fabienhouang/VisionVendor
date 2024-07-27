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
  // police : forte regular 
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFFFD700), // Primary color
        scaffoldBackgroundColor: Colors.white, // Scaffold background color
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFFFD700), // Button background color
          textTheme: ButtonTextTheme.primary,
                          
          disabledColor: Color(0xFF4169E1), // Icon color: Theme.of(context).focusColor, // Background color
          focusColor: Colors.red, // Focus color
          hoverColor: Colors.blueAccent, // Hover color
          splashColor: Colors.cyan, // Splash color
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFD700), // Floating action button color
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF4169E1), // Icon color
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4169E1)),
          ),
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFFFFD700),
            titleTextStyle: TextStyle(fontSize: 22, color: Color(0xFF4169E1)),
            centerTitle: true,
          ),
      ),

      darkTheme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

