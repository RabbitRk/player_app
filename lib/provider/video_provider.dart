import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:player_app/misc/file_utils.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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
  List<FolderElement> folder_element = [];

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

  Future<String> genThumbnail(ThumbnailRequest r) async {
    //WidgetsFlutterBinding.ensureInitialized();
    // Uint8List bytes;
    // final Completer<ThumbnailResult> completer = Completer();
    // var thumbnailPath = "";
    // if (r.thumbnailPath != null) {
    var thumbnailPath = (await VideoThumbnail.thumbnailFile(
        video: r.video,
        thumbnailPath: r.thumbnailPath,
        imageFormat: r.imageFormat,
        maxHeight: r.maxHeight,
        maxWidth: r.maxWidth,
        timeMs: r.timeMs,
        quality: r.quality))!;

    print("thumbnail file is located: $thumbnailPath");

    // bytes = file.readAsBytesSync();
    // } else {

    // thumbnailPath = "";
    // bytes = (await VideoThumbnail.thumbnailData(
    //     video: r.video,
    //     imageFormat: r.imageFormat,
    //     maxHeight: r.maxHeight,
    //     maxWidth: r.maxWidth,
    //     timeMs: r.timeMs,
    //     quality: r.quality))!;
    // }

    // int _imageDataSize = bytes.length;
    // print("image size: $_imageDataSize");

    // final _image = Image.memory(bytes);
    // _image.image
    //     .resolve(ImageConfiguration())
    //     .addListener(ImageStreamListener((ImageInfo info, bool _) {
    //   completer.complete(ThumbnailResult(
    //     image: _image,
    //     dataSize: _imageDataSize,
    //     height: info.image.height,
    //     width: info.image.width,
    //   ));
    // }));
    // return completer.future;
    return thumbnailPath;
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

  Future getSubDirectory(bool isHidden, String folder) async {
    print(folder);
    //Emptying Folder
    // this.folder_ = List<String>.empty();
    file_element = [];
    folder_element = [];
    folder_ = [];
    // Getting sub-directory
    List<FileSystemEntity> directory = await FileUtils.getFilesInPath(folder);
    print(directory.length);
    String? image;

    for (var dir in directory) {
      if (dir is File) {
        if (extensions.contains(FileUtils.getMime(dir.path))) {
          var info = await FlutterVideoInfo().getVideoInfo(dir.path);
          var time = Duration(milliseconds: info!.duration!.toInt());
          var size = FileUtils.formatBytes(info.filesize!, 1);

          genThumbnail(
            ThumbnailRequest(
              video: dir.path,
              thumbnailPath: (await getTemporaryDirectory()).path,
              imageFormat: ImageFormat.WEBP,
              maxHeight: 90,
              maxWidth: 160,
              quality: 75,
              timeMs: 0,
            ),
          ).then((value) {
            image = value;
          }).whenComplete(() {
            print(image);
            file_element.add(FileElement(
                fileName: dir.path.split("/").last,
                filePath: dir.path,
                duration: time.toString().split('.')[0],
                filesize: size,
                thumbnail: image));
            notifyListeners();
            print("data");
          });
        }
      } else if (dir is Directory) {
        if (!basename(dir.path).startsWith(".")) {
          List<FileSystemEntity> sub =
              await FileUtils.getAllFilesInPath(dir.path, false);
          sub.forEach((sub) {
            if (extensions.contains(FileUtils.getMime(sub.path))) {
              if (!folder_.contains(dir.path.split("/").last)) {
                //Adding folder name to array to add distinct value
                folder_.add(dir.path.split("/").last);
                folder_element.add(FolderElement(
                    folderName: dir.path.split("/").last, rootPath: dir.path));
                notifyListeners();

              }
            }
          });
        }
      }
    }


  }

  Future<String> genThumbnail(ThumbnailRequest r) async {
    //WidgetsFlutterBinding.ensureInitialized();
    // Uint8List bytes;
    // final Completer<ThumbnailResult> completer = Completer();
    // var thumbnailPath = "";
    // if (r.thumbnailPath != null) {
    var thumbnailPath = (await VideoThumbnail.thumbnailFile(
        video: r.video,
        thumbnailPath: r.thumbnailPath,
        imageFormat: r.imageFormat,
        maxHeight: r.maxHeight,
        maxWidth: r.maxWidth,
        timeMs: r.timeMs,
        quality: r.quality))!;

    print("thumbnail file is located: $thumbnailPath");

    // bytes = file.readAsBytesSync();
    // } else {

    // thumbnailPath = "";
    // bytes = (await VideoThumbnail.thumbnailData(
    //     video: r.video,
    //     imageFormat: r.imageFormat,
    //     maxHeight: r.maxHeight,
    //     maxWidth: r.maxWidth,
    //     timeMs: r.timeMs,
    //     quality: r.quality))!;
    // }

    // int _imageDataSize = bytes.length;
    // print("image size: $_imageDataSize");

    // final _image = Image.memory(bytes);
    // _image.image
    //     .resolve(ImageConfiguration())
    //     .addListener(ImageStreamListener((ImageInfo info, bool _) {
    //   completer.complete(ThumbnailResult(
    //     image: _image,
    //     dataSize: _imageDataSize,
    //     height: info.image.height,
    //     width: info.image.width,
    //   ));
    // }));
    // return completer.future;
    return thumbnailPath;
  }
}

class Folder {
  Folder({
    this.folderName,
    this.dirtCount,
    this.fileCount,
    this.isVideo,
    this.rootPath,
  });

  String? folderName;
  int? dirtCount;
  bool? isVideo;
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
  FileElement(
      {required this.fileName,
      required this.filePath,
      this.duration,
      this.filesize,
        this.isVideo = true,
      this.thumbnail});

  String fileName;
  String filePath;
  String? duration;
  bool? isVideo;
  String? filesize;
  String? thumbnail;
}

class FolderElement {
  FolderElement({
    this.folderName,
    this.dirtCount,
    this.fileCount,
    this.rootPath,
    this.isVideo = false,
    this.thumbnail,
  });

  String? folderName;
  String? dirtCount;
  String? fileCount;
  String? rootPath;
  bool? isVideo;
  String? thumbnail;
}

class ThumbnailRequest {
  final String video;
  final String thumbnailPath;
  final ImageFormat imageFormat;
  final int maxHeight;
  final int maxWidth;
  final int timeMs;
  final int quality;

  const ThumbnailRequest(
      {required this.video,
      required this.thumbnailPath,
      required this.imageFormat,
      required this.maxHeight,
      required this.maxWidth,
      required this.timeMs,
      required this.quality});
}

class ThumbnailResult {
  final Image? image;
  final int? dataSize;
  final int? height;
  final int? width;

  const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}
