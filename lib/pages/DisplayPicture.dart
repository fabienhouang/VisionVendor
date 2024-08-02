import 'dart:io';
import '../widgets/InstaImageViewer.dart';
import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';

Color getConditionColor(String condition) {
      switch (condition) {
        case 'New':
          return Colors.green;
        case 'Good':
          return Colors.lightGreenAccent;
        case 'Used':
          return Colors.yellow;
        case 'Damaged':
          return Colors.orange;
        case 'Broken':
          return Colors.red;
        default:
          return Colors.black;
      }
    }
// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final Map<String, dynamic> res;

  DisplayPictureScreen({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text("Item Description",
                style: TextStyle(fontWeight: FontWeight.bold),
           ),
        )
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SingleChildScrollView(
        child: SelectionArea(
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
                        borderRadius: BorderRadius.circular(10.0),
                        child: InstaImageViewer(
                          child: Image.file(File(res['imagePath']),),
                        )
                      )
                    ),
                  ),
                  Expanded(
                    flex: 6, // 60%
                    child: Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              res['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Brand: " + res['brand'],
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 3,),
                          Divider(),
                          SizedBox(height: 2,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Condition : " + res['condition'],
                                style: TextStyle(fontSize: 14),
                              ),
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
                          Text(
                            "Retail : \$" + res['retail_price'].toString(),
                            style: TextStyle(fontSize: 14,),
                          ),
                          Text("Resale Price :"),
                          LinearGauge(
                            start: double.parse(res['min_resale'].toString()),
                            end: double.parse(res['max_resale'].toString()),
                            steps: (double.parse(res['max_resale'].toString()) - double.parse(res['min_resale'].toString())) / 2,
                            gaugeOrientation: GaugeOrientation.horizontal,
                            enableGaugeAnimation: true,
                            animationDuration: 3000,
                            linearGaugeBoxDecoration: const LinearGaugeBoxDecoration(
                                thickness: 5,
                                linearGradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 255, 114, 107),
                                  Color.fromARGB(255, 255, 165, 0),
                                  Color.fromARGB(255, 107, 255, 115)
                                ])),
                            pointers: [
                              Pointer(
                                value: double.parse(res['avg_resale'].toString()),
                                shape: PointerShape.triangle,
                                color: Theme.of(context).textTheme.bodyMedium!.color!,
                                pointerPosition: PointerPosition.top,
                              ),
                            ],
                            extendLinearGauge: 10,
                            customLabels: [
                              CustomRulerLabel(text: "\$"+ res['min_resale'].toString(), value: double.parse(res['min_resale'].toString())),
                              CustomRulerLabel(text: "\$"+ res['avg_resale'].toString(), value: double.parse(res['avg_resale'].toString())),
                              CustomRulerLabel(text: "\$"+ res['max_resale'].toString(), value: double.parse(res['max_resale'].toString())),
                            ],
                            rulers: RulerStyle(
                              inverseRulers: false,
                              rulerPosition: RulerPosition.bottom,
                              labelOffset: 5,
                              rulersOffset: 5,
                              primaryRulersHeight: 5,
                              secondaryRulersHeight: 3,
                              textStyle: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  )
                ]
              ),
              SizedBox(height: 5),
              Divider(),
              Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                res['description'],
                style: TextStyle(fontSize: 14),
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
                          ListTile(
                            leading: Icon(Icons.link,),
                            title: Text('Link'),
                            subtitle: Text(res['link']),
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
      )
    );
  }
}
