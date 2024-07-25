import 'dart:io';

import 'package:flutter/material.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final Map<String, dynamic> res;

  DisplayPictureScreen({super.key, required this.imagePath, required this.res});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        // backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  padding: EdgeInsets.only(right: 1),
                  child: Center(
                    child: Image.file(File(imagePath)),
                  ),
                ),
                // SizedBox(width: 8),
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width - 100,
                  padding: EdgeInsets.all(1),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          'Bâtonnets glacés aux fruits',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          softWrap: true,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Picard',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.green,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '90/100',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Excellent',
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text(
              'Positives',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            PositiveItem(
              icon: Icons.check,
              label: 'No additives',
              value: 'No hazardous substances',
            ),
            PositiveItem(
              icon: Icons.local_florist,
              label: 'Fruits',
              value: 'Excellent quantity',
            ),
            PositiveItem(
              icon: Icons.fiber_manual_record,
              label: 'Fiber',
              value: 'Some fiber',
            ),
            PositiveItem(
              icon: Icons.local_fire_department,
              label: 'Calories',
              value: 'Low calories',
            ),
            PositiveItem(
              icon: Icons.opacity,
              label: 'Saturated fat',
              value: 'Low sat. fat',
            ),
          ],
        ),
      ),
    );
  }
}

class PositiveItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  PositiveItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Item Description')),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: Column(
//         children: <Widget>[
//           Container(
//             margin: const EdgeInsets.all(10.0),
//             width: 400.0,
//             height: 400.0,
//             child: Image.file(File(imagePath)),
//           ),

//           ListView.builder(
//               scrollDirection: Axis.vertical,
//               shrinkWrap: true,
//               itemCount: res.length,
//               itemBuilder: (BuildContext context, int index) {
//                 String key = res.keys.elementAt(index);
//                 return Text("$key : ${res[key]!}");
//               }),
//           //Text(res.length.toString())
//         ],
//       )
//     );
//   }
// }
