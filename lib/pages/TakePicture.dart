import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import '../globals/model.dart';
import 'DisplayPicture.dart';
import '../widgets/BottomHistorySheet.dart';
import '../utils/showError.dart';




// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<Map<String, dynamic>> results = [Map<String, dynamic>()];
  int _loading = 0;
  bool isCamera = false;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
      enableAudio: false
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision Vendor'),
      ),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Stack(children: [
        Row(children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return CameraPreview(_controller);
                  } else {
                    // Otherwise, display a loading indicator.
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ]),
        BottomHistorySheet(results: results)
      ]),
      floatingActionButton: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(left: 35),
              child: FloatingActionButton(
                onPressed: _loading == 0 ? () async {
                  isCamera = false;
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    await _handleImage(image.path);
                  } else {
                    showError(context, 'No image selected.');
                  }
                } : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_loading > 0 && !isCamera) const CircularProgressIndicator() else const Icon(Icons.add_photo_alternate),
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
            Container(
              child: FloatingActionButton(
                onPressed: _loading == 0 ? () async {
                  try {
                    isCamera = true;
                    // Attempt to take a picture and get the file `image`
                    // where it was saved.
                    await _initializeControllerFuture;

                    // Attempt to take a picture and get the file `image`
                    // where it was saved.
                    final image = await _controller.takePicture();

                    if (!context.mounted) return;
                    await _handleImage(image.path);
                  }
                  catch (e) {
                    showError(context, e.toString());
                  }
                } : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_loading > 0 && isCamera ) const CircularProgressIndicator() else const Icon(Icons.camera_alt) ,
                  ],
                ),
              )
            )
          ],
        ),
      )
    );
  }

  Future<void> _handleImage(String imagePath) async {
    await _sendImagePrompt(imagePath);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(
          res: results[results.length - 1],
        ),
      ),
    );
  }

  Future<void> _sendImagePrompt(String imagePath) async {
    setState(() {
      _loading += 1;
    });

    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final content = [
        Content.multi([
          TextPart(prompt),
          // The only accepted mime types are image/*.
          DataPart('image/*', imageBytes.buffer.asUint8List())
        ])
      ];

      var response = await model.generateContent(content).timeout(const Duration(seconds: 10));

      if (response == null) {
        showError(context, 'No response from API.');
        return;
      }

      var res = jsonDecode(response.text!) as Map<String, dynamic>;
      res["imagePath"] = imagePath;

      setState(() {
        results.add(res);
      });

    } catch (e) {
      showError(context, e.toString());
    } finally {
      setState(() {
        _loading -= 1;
      });
    }
  }
}
