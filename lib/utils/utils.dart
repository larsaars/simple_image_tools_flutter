import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_image_tools/crop/src/crop.dart';

// the set input file
var inputFile = File('C:\\Users\\larsl\\Downloads\\20210330_182647.jpg');
// from the input file read all files in same folder for switching (right left)
List<File> files = [];
int filesIdx = 0;
// default aspect ratio
double ogAspectRatio = 1;
// control the crop
final controller = CropController();

// determine the folder and all files in there
void setFiles() {
  // exit app immediately if file does not exist
  if (!inputFile.existsSync()) exit(0);
  // clear list firstly
  files.clear();
  // add all image files to list
  for (var entry in inputFile.parent.listSync().where((element) {
    // determine if single element is image
    // if is not file return false
    if (FileSystemEntity.typeSync(element.path) != FileSystemEntityType.file)
      return false;

    final split = element.path.split('.');

    if (split.length == 0) return false;

    return IMG_EXTENSIONS.contains(split.last.toLowerCase());
  })) {
    // add file
    files.add(File(entry.path));
  }

  // sort list with names to lower case
  files.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));

  // set index index file
  filesIdx = files.indexWhere((element) => element.path == inputFile.path);

  // set image with direction neutral
  switchImage(0);
}

// bool if can switch image (with direction)
bool canSwitchImage(int dir) {
  int newIdx = filesIdx + dir;
  return newIdx >= 0 && newIdx < files.length;
}

Future<void> switchImage(int dir) async {
  // check again if can switch (is async)
  if (!canSwitchImage(dir)) return;
  // set new index
  filesIdx += dir;
  // calc default aspect ratio
  // for that load it again from file
  var decodedImage = await decodeImageFromList(file.readAsBytesSync());
  ogAspectRatio =
      decodedImage.width.toDouble() / decodedImage.height.toDouble();

  // set controllers aspect ratio default to og
  controller.aspectRatio = ogAspectRatio;
  // reset also other values of controller
  controller.scale = 1;
  controller.offset = Offset.zero;
  controller.rotation = 0;
}

File get file => files[filesIdx];

bool get platformIsDesktop =>
    Platform.isLinux || Platform.isMacOS || Platform.isWindows;

const IMG_EXTENSIONS = const ['jpeg', 'jpg', 'png', 'gif', 'webp'];

void addLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
        ['crop'], await rootBundle.loadString('assets/licenses/CROP'));
  });
}
