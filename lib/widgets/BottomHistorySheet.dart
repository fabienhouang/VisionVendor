import 'dart:io';

import 'package:flutter/material.dart';

import '../pages/DisplayPicture.dart';

// A widget that displays the picture taken by the user.
class BottomHistorySheet extends StatelessWidget {
  final List<Map<String, dynamic>> results;

  BottomHistorySheet({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.05,
      minChildSize: 0.05,
      maxChildSize: 1,
      snapSizes: [0.05, 1],
      snap: true,
      builder: (BuildContext context, ScrollController scrollSheetController) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
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
              return ItemCard(res: res);
            },
          )
        );
      }
    );
  }
}

class ItemCard extends StatelessWidget {
  final Map<String, dynamic> res;

  ItemCard({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(
              // Pass the automatically generated path to
              // the DisplayPictureScreen widget.
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
          subtitle:
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Brand: " + res["brand"]),
                  ),
                  Expanded(
                    child:Row(
                      children: [
                        Text("Condition: " + res["condition"]),
                        SizedBox(width: 5),
                        Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: getConditionColor(res['condition']),
                                    shape: BoxShape.circle,
                                  ),
                              )
                      ],
                    ),
                  )
                ]
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Retail: \$" + res["retail_price"].toString()),
                  ),
                  Expanded(
                    child:Text("Resale: \$" + res["min_resale"].toString() + '-\$' + res["max_resale"].toString()),
                  )
                ]
              ),
            ]
          )
        ),
      )
    );
  }
}