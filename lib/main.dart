import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'TakePicture.dart';

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
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.orange,
          ),
          // scaffoldBackgroundColor: Colors.orange[100],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.amber,
            titleTextStyle: TextStyle(fontSize: 25, color: Colors.blueAccent),
            centerTitle: true,
            // toolbarHeight: 40,
          ),
          useMaterial3: true),
      darkTheme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}
