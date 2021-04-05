import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_image_tools/strings.dart';

import 'crop/crop.dart';
import 'widgets/centered_slider_track_shape.dart';

void main() {
  runApp(MyApp());
}

Strings s = Strings();
File file = File('D:/FlutterProjects/simple_image_tools/test_image.jpg');

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: s.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = CropController();
  double _rotation = 0;
  BoxShape shape = BoxShape.rectangle;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          file.path,
          maxLines: 1,
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.all(8),
                child: Crop(
                  interactive: true,
                  onChanged: (decomposition) {
                    print(
                        "Scale : ${decomposition.scale}, Rotation: ${decomposition.rotation}, translation: ${decomposition.translation}");
                  },
                  controller: controller,
                  shape: shape,
                  child:
                      /*Image.file(
                    file,
                    fit: BoxFit.cover,
                  ),*/
                      Image.asset('assets/imgs/test_image.jpg'),
                  helper: shape == BoxShape.rectangle
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        )
                      : null,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.undo),
                  tooltip: s.undo,
                  onPressed: () {
                    controller.rotation = 0;
                    controller.scale = 1;
                    controller.offset = Offset.zero;
                    setState(() {
                      _rotation = 0;
                    });
                  },
                ),
                Expanded(
                  child: SliderTheme(
                    data: Theme.of(context).sliderTheme.copyWith(
                          trackShape: CenteredRectangularSliderTrackShape(),
                        ),
                    child: Slider(
                      divisions: 360,
                      value: _rotation,
                      min: -180,
                      max: 180,
                      label: '$_rotation°',
                      onChanged: (n) {
                        setState(() {
                          _rotation = n.roundToDouble();
                          controller.rotation = _rotation;
                        });
                      },
                    ),
                  ),
                ),
                PopupMenuButton<BoxShape>(
                  icon: Icon(Icons.crop_free),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text(s.box),
                      value: BoxShape.rectangle,
                    ),
                    PopupMenuItem(
                      child: Text(s.oval),
                      value: BoxShape.circle,
                    ),
                  ],
                  tooltip: s.cropShape,
                  onSelected: (x) {
                    setState(() {
                      shape = x;
                    });
                  },
                ),
                PopupMenuButton<double>(
                  icon: Icon(Icons.aspect_ratio),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text(s.original),
                      value: 1000 / 667.0,
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      child: Text("16:9"),
                      value: 16.0 / 9.0,
                    ),
                    PopupMenuItem(
                      child: Text("4:3"),
                      value: 4.0 / 3.0,
                    ),
                    PopupMenuItem(
                      child: Text("1:1"),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Text("3:4"),
                      value: 3.0 / 4.0,
                    ),
                    PopupMenuItem(
                      child: Text("9:16"),
                      value: 9.0 / 16.0,
                    ),
                  ],
                  tooltip: s.aspectRatio,
                  onSelected: (x) {
                    controller.aspectRatio = x;
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
