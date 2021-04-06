import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:simple_image_tools/utils/utils.dart';

import 'crop/src/crop.dart';
import 'widgets/centered_slider_track_shape.dart';

void main() {
  // run the app
  runApp(MyApp());
}

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
  double _rotation = 0, _scale = 1;
  BoxShape shape = BoxShape.rectangle;

  @override
  void initState() {
    super.initState();
    // determine the folder and all files in there
    setFiles();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          file.path,
          maxLines: 1,
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleMenuClick,
            itemBuilder: (BuildContext context) {
              return {s.cropCopy, s.about}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                ),
                onPressed: () =>
                    switchImage(-1).then((value) => setState(() {
                      controller.recenter();
                    }))),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                // show only on desktop
                platformIsDesktop
                    ? Row(
                        children: [
                          Expanded(
                            child: SliderTheme(
                              data: Theme.of(context).sliderTheme,
                              child: Slider(
                                divisions: 100,
                                value: math.min(_scale, 11),
                                min: 1,
                                max: 11,
                                label: _scale.toStringAsFixed(1),
                                onChanged: (n) {
                                  setState(() {
                                    _scale = n.toDouble();
                                    controller.scale = _scale;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Expanded(
                  child: Container(
                    color: Colors.black,
                    padding: EdgeInsets.all(8),
                    child: Crop(
                      autoRecenter: false,
                      interactive: true,
                      controller: controller,
                      shape: shape,
                      child: file.existsSync()
                          ? Image.file(
                              file,
                              fit: BoxFit.cover,
                            )
                          : Image.asset('assets/imgs/def.jpg'),
                      helper: shape == BoxShape.rectangle
                          ? Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
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
                          _scale = 1;
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
                          value: ogAspectRatio,
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
          Center(
            child: IconButton(
                icon: Icon(
                  Icons.chevron_right,
                ),
                onPressed: () =>
                    switchImage(1).then((value) => setState(() {
                      controller.recenter();
                    }))),
          ),
        ],
      ),
    );
  }

  void handleMenuClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }
}
