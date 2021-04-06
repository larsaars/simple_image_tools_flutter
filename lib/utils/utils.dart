import 'dart:io';

import 'package:mime/mime.dart';
import 'package:simple_image_tools/utils/strings.dart';

// all strings
final s = Strings();
// the set input file
var inputFile = File('D:/FlutterProjects/simple_image_tools/test_image.jpg');
// from the input file read all files in same folder for switching (right left)
List<File> files = [];
int filesIdx = 0;

// determine the folder and all files in there
void setFiles() {
  // clear list firstly
  files.clear();
  // add all image files to list
  for (var entry in inputFile.parent.listSync().where((element) {
    // determine if single element is image
    final mimeType = lookupMimeType(element.path);
    if (mimeType == null)
      return false;
    else {
      return mimeType.split('/')[0] == 'image';
    }
  })) {
    // add file
    files.add(File(entry.path));
  }

  // sort list with names to lower case
  files.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));

  // set index index file
  filesIdx = files.indexWhere((element) => element.path == inputFile.path);
}

File get file => files[filesIdx];

bool get platformIsDesktop =>
    Platform.isLinux || Platform.isMacOS || Platform.isWindows;
