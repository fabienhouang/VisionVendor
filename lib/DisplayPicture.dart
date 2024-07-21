import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_generative_ai/google_generative_ai.dart';

import 'global/model.dart';

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
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  width: 400.0,
                  height: 400.0,
                  child: Image.file(File(imagePath)),
                ),

                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _res.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = _res.keys.elementAt(index);
                      return Text("$key : ${_res[key]!}");
                    }),
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

    var response = await model.generateContent(content);
    _res = jsonDecode(response.text!) as Map<String, dynamic>;
  }
}
