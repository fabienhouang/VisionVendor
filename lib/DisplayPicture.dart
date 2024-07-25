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
  final Map<String, dynamic> res;

  DisplayPictureScreen({super.key, required this.imagePath, required this.res});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Item Description')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Column(
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
                itemCount: res.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = res.keys.elementAt(index);
                  return Text("$key : ${res[key]!}");
                }),
            //Text(res.length.toString())
          ],
        ));
  }
}
