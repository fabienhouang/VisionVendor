import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'DisplayPicture.dart';
//import 'BottomHistorySheet.dart';

import 'global/model.dart';

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
        FutureBuilder<void>(
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
        DraggableScrollableSheet(
          initialChildSize: 0.05,
          minChildSize: 0.05,
          maxChildSize: 1,
          snapSizes: [0.05, 1],
          snap: true,
          builder: (BuildContext context, ScrollController scrollSheetController ) {
            return Container(
              color: Colors.black,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: ClampingScrollPhysics(),
                controller: scrollSheetController,
                itemCount: results.length,
                itemBuilder: (BuildContext context, int index) {
                  final res = results[index];
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.all(2),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 200,
                            child: Divider(
                              thickness: 5,
                            ),
                          ),
                          Text('Swipe up for results')
                        ],
                      )
                    );
                  }
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                            // Pass the automatically generated path to
                            // the DisplayPictureScreen widget.
                            imagePath: res["imagePath"],
                            res: res
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                      margin: EdgeInsets.all(1),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                        visualDensity: VisualDensity(vertical: 4),
                        dense: true,
                        leading: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            return SizedBox(
                              height: constraints.maxHeight,
                              width: constraints.maxWidth/5,
                              child: Image.file(File(res["imagePath"]),
                                fit:BoxFit.cover,
                              )
                            );
                          }
                        ),
                        title: Text(res["Description"]),
                        subtitle: Row(
                          children: <Widget>[
                            Text("Retail Price:" + res["Retail Price"]),
                            Text(", \tResell Price:" + res["Lowest Resell"] + '-' + res["Average Resell"]),
                          ]
                        ),
                      ),
                    )
                  );
                },
              )
            );
          }
        )
      ]),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            await _sendImagePrompt(image.path);

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                  res: results[results.length-1]
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_loading == 0)
              const Icon(Icons.camera_alt)
            else
              const CircularProgressIndicator(),
          ]
        )
      ),
    );
  }

  Future<void> _sendImagePrompt(String imagePath) async {
    setState(() {
      _loading += 1;
    });
    final imageBytes = await File(imagePath).readAsBytes();
    final content = [
      Content.multi([
        TextPart(prompt),
        // The only accepted mime types are image/*.
        DataPart('image/*', imageBytes.buffer.asUint8List())
      ])
    ];

    var response = await model.generateContent(content);
    var res = jsonDecode(response.text!) as Map<String, dynamic>;
    res["imagePath"] = imagePath;

    setState(() {
      results.add(res);
      _loading -= 1;
    });
  }
}
