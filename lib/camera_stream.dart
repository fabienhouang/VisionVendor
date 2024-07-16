import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:google_generative_ai/google_generative_ai.dart';

// Access your API key as an environment variable (see "Set up your API key" above)
const String _apiKey = String.fromEnvironment('API_KEY');

const instruction = """you're used as the backend of our application called Vision Vendor where the goal is to estimate goods state, price, condition ...
You're main task is to analyze images and make some KPIs out of it
You'll also be tasked to identify and detect objects plus their boxes""";

final generationConfig = GenerationConfig(
  responseMimeType: "application/json"
);

final _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: _apiKey, systemInstruction: Content.system(instruction), generationConfig: generationConfig);

const prompt = """Je dois analyser cette image pour en sortir des informations imporatnes pour la vente d'ocassion pour mon application.
Essaie de trouver vraiment un titre qui correspond au mieux à l'objet à vendre.
Même si les estimations de prix ne sont pas bonnes ce n'est pas grave je souhaite juste avoir un chiffre à titre indicatif
Le but est de sortir sous format JSON les KPIs suivant :

KPIs = {'Description': str, 'Retail Price': float, 'Condition': str IN {Neuf, Très bon état, Comme neuf, Bon état, Etat correct }, 'Average Resell': float, 'Highest Resell': float, 'Lowest Resell': float}
Return: KPIs""";


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
      appBar: AppBar(title: const Text('Vision Vendor')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
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

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  Map<String, dynamic> _res = {};

  DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Item Description')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: FutureBuilder<void>(
        future: _sendImagePrompt(imagePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Column(
                children: <Widget> [
                Image.file(File(imagePath)),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _res.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = _res.keys.elementAt(index);
                    return Text(key + " : " + (_res[key]!.toString()));
                  }
                ),
                //Text(_res.length.toString())
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),

    );
  }

  Future<void> _sendImagePrompt(String imagePath) async {

      final imageBytes = await File(imagePath).readAsBytes();
      final content = [
        Content.multi([
          TextPart(prompt),
          // The only accepted mime types are image/*.
          DataPart('image/*', imageBytes.buffer.asUint8List())
        ])
      ];

      var response = await _model.generateContent(content);
      _res = jsonDecode(response.text!) as Map<String, dynamic>;

  }
}
