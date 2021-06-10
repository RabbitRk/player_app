import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:player_app/misc/file_utils.dart';

class FolderModel extends ChangeNotifier {
  List<String> folder = [];
  List<String> extensions = [
    "video/flv",
    "video/mp4",
    "video/3gp",
    "video/mov",
    "video/avi",
    "video/wmv"
  ];

  List<Folder> folders = [];
  List<FileElement> file_element = [];
  List<SubFolder> folder_element = [];

  Folder fol = new Folder();

  void getHomeDirectory(bool isHidden) async {
    List<FileSystemEntity> storage = await FileUtils.getAllFiles(isHidden);
    storage.forEach((element) async {
      FileSystemEntity dir = element;
      if (extensions.contains(FileUtils.getMime(element.path))) {
        if (!folder.contains(element.path.split("/")[4])) {
          //Adding folder name to array to add distinct value
          folder.add(element.path.split("/")[4]);

          //Adding folder name
          fol = new Folder();
          fol.folderName = element.path.split("/")[4];
          fol.rootPath = "/storage/emulated/0/" + fol.folderName!;
          fol.dirtCount = element.path.split("/").length;
          fol.fileCount = "0";

          folders.add(fol);
        }
      }
    });

    notifyListeners();
  }

  void getSubDirectory(bool isHidden, String folder) async {
    //Emptying Folder
    this.folder = List<String>.empty();

    // Getting sub-directory
    List<FileSystemEntity> subdirectory =
        await FileUtils.getFilesInPath(folder);
    subdirectory.forEach((sub) {
      if (extensions.contains(FileUtils.getMime(sub.path))) {
        file_element.add(FileElement(
            fileName: sub.path.split("/").last, filePath: sub.path));
      }
      // else {
      //   //getting sub directory
      //   print(sub.path);
      // }
    });

    notifyListeners();
  }
}

class SubFolderModel extends ChangeNotifier {
  List<String> folder_ = [];
  List<String> extensions = [
    "video/flv",
    "video/mp4",
    "video/3gp",
    "video/mov",
    "video/avi",
    "video/wmv"
  ];

  List<FileElement> file_element = [];
  List<FolderElement> folder_element = [];

  bool _disposed = false;

  void getSubDirectory(bool isHidden, String folder) async {
    print(folder);
    //Emptying Folder
    // this.folder_ = List<String>.empty();
    file_element = [];
    folder_element = [];
    folder_ = [];
    // Getting sub-directory
    List<FileSystemEntity> directory =
        await FileUtils.getFilesInPath(folder);
    print(directory.length);

    for (var dir in directory) {
      if (dir is File) {
        if (extensions.contains(FileUtils.getMime(dir.path))) {
          var info =  await FlutterVideoInfo().getVideoInfo(dir.path);
          var time = Duration(milliseconds: info!.duration!.toInt());
          var size = FileUtils.formatBytes(info.filesize!, 1);
          file_element.add(FileElement(
              fileName: dir.path.split("/").last, filePath: dir.path, duration: time.toString().split('.')[0], filesize: size));
        }
      } else if (dir is Directory) {
        if (!basename(dir.path).startsWith(".")) {
          List<FileSystemEntity> sub = await FileUtils.getAllFilesInPath(dir.path, false);
          sub.forEach((sub) {
            if (extensions.contains(FileUtils.getMime(sub.path))) {
              if (!folder_.contains(dir.path.split("/").last)) {
                //Adding folder name to array to add distinct value
                folder_.add(dir.path.split("/").last);
                folder_element.add(FolderElement(
                    folderName: dir.path.split("/").last, rootPath: dir.path));
              }
            }
          });
        }
      }
    }

    notifyListeners();
  }

  // @override
  // void dispose() {
  //   _disposed = true;
  //   super.dispose();
  // }
  //
  // @override
  // void notifyListeners() {
  //   if (!_disposed) {
  //     super.notifyListeners();
  //   }
  // }
}

class Folder {
  Folder({
    this.folderName,
    this.dirtCount,
    this.fileCount,
    this.rootPath,
  });

  String? folderName;
  int? dirtCount;
  String? fileCount;
  String? rootPath;
}

class SubFolder {
  SubFolder({
    this.folderName,
    this.dirtCount,
    this.fileCount,
    this.rootPath,
    this.folder,
    this.files,
  });

  String? folderName;
  String? dirtCount;
  String? fileCount;
  String? rootPath;
  List<FolderElement>? folder;
  List<FileElement>? files;
}

class FileElement {
  FileElement({
    required this.fileName,
    required this.filePath,
    this.duration,
    this.filesize,
  });

  String fileName;
  String filePath;
  String? duration;
  String? filesize;
}

class FolderElement {
  FolderElement({
    this.folderName,
    this.dirtCount,
    this.fileCount,
    this.rootPath,
  });

  String? folderName;
  String? dirtCount;
  String? fileCount;
  String? rootPath;
}
