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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text("Item Description")
        )
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4, // 40%
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 200, minWidth: 100, maxHeight: 400
                      ),
                      height: height/4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.file(File(imagePath), fit: BoxFit.cover),
                      )
                    ),
                  ),
                  Expanded(
                    flex: 6, // 60%
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child : Column(
                        children: <Widget>[
                          Text(
                            res['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Brand: " + res['brand'],
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Condition: " + res['condition'],
                            style: TextStyle(fontSize: 14,),
                          ),
                          Text(
                            "Retail: " + res['retail_price'],
                            style: TextStyle(fontSize: 14,),
                          ),
                          Text(
                            "Resale: " + res['min_resale'] + '-' + res['max_resale'],
                            style: TextStyle(fontSize: 14,),
                          ),
                          Text(
                            res['avg_resale'],
                            style: TextStyle(fontSize: 14,),
                          ),
                        ],
                      ),
                    )
                  )
                ]
              ),
              SizedBox(height: 12),
              Divider(),
              Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                res['description'],
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 12),
              Divider(),
              Text(
                'Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Container(

                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.grid_view,),
                            title: Text('Category'),
                            subtitle: Text(res['category']),
                          ),
                          ListTile(
                            leading: Icon(Icons.build,),
                            title: Text('Materials'),
                            subtitle: Text(res['materials']),
                          ),
                          ListTile(
                            leading: Icon(Icons.palette,),
                            title: Text('Colors'),
                            subtitle: Text(res['colors']),
                          ),
                          ListTile(
                            leading: Icon(Icons.scale,),
                            title: Text('Weight'),
                            subtitle: Text(res['weight']),
                          ),
                        ],
                      ),
                    )
                  ),
                ]
              )

              /*ListView.builder( //For debug
                shrinkWrap: true,
                itemCount: res.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = res.keys.elementAt(index);
                  return Text("$key : ${res[key]!}");
                }
              ),*/
              //Text(res.length.toString())
            ],
          )
        )
      )
    );
  }
}
