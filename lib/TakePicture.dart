import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'DisplayPicture.dart';
//import 'BottomHistorySheet.dart';

import 'global/model.dart';
import 'package:image_picker/image_picker.dart';

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
                        title: Text(res["title"]),
                        subtitle: Row(
                          children: <Widget>[
                            Text("Retail Price:" + res["retail_price"]),
                            Text(", \tResale Price:" + res["min_resale"] + '-' + res["avg_resale"]),
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
                    _showError('No image selected.');
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
                    _showError(e.toString());
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
          imagePath: imagePath,
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

      var response = await model.generateContent(content);

      if (response == null) {
        _showError('No response from API.');
        return;
      }

      var res = jsonDecode(response.text!) as Map<String, dynamic>;
      res["imagePath"] = imagePath;

      setState(() {
        results.add(res);
      });

    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        _loading -= 1;
      });
    }
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
