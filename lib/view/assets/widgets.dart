import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:player_app/misc/colors.dart';
import 'package:player_app/misc/svg.dart';
import 'package:player_app/provider/model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class TextBox extends StatefulWidget {
  final Function(String) onChanged;

  const TextBox({Key? key, required this.onChanged}) : super(key: key);

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: bDecoration,
        child: TextField(
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 16, color: Colors.black),
          textAlign: TextAlign.left,
          decoration: const InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search, size: 24),
              filled: true,
              isDense: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide.none),
              counterText: "",
              contentPadding: EdgeInsets.all(16),
              hintStyle: TextStyle(color: Colors.grey)),
          onChanged: (s) => widget.onChanged(s),
        ),
      ),
    );
  }
}

class SvgIcon extends StatelessWidget {
  final String icon;
  final Color color, background;
  final double size, padding, radius;
  final double height;
  final double width;
  final Function() onTap;

  const SvgIcon(
      {Key? key,
      required this.icon,
      this.color = white,
      this.size = 22,
      this.background = secondaryColor,
      this.padding = 8,
      this.radius = 4,
      required this.onTap,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
            color: background, borderRadius: BorderRadius.circular(radius)),
        child: Center(
          child: SvgPicture.asset(
            icon,
            color: color,
            matchTextDirection: true,
            height: size,
            width: size,
          ),
        ),
      ),
    );
  }
}

class FolderDetail extends StatefulWidget {

  final String folder_name, file, folder;

  const FolderDetail({Key? key, required this.folder_name, required this.file, required this.folder}) : super(key: key);

  @override
  _FolderDetailState createState() => _FolderDetailState();
}

class _FolderDetailState extends State<FolderDetail> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          SvgPicture.asset(
            svg_.foldericon,
            matchTextDirection: true,
            color: white,
            height: 70,
            width: 76,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 36.0, vertical: 8.0),
                child: Text(
                  widget.folder_name,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 28.0,
                  ),
                  SvgIcon(
                    icon: svg_.play,
                    height: 32,
                    width: 32,
                    size: 16,
                    background: Colors.transparent,
                    color: accentColor,
                    padding: 0,
                    radius: 8,
                    onTap: () => null,
                  ),
                  Text(
                    widget.file,
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  SvgIcon(
                    icon: svg_.folder,
                    height: 32,
                    width: 32,
                    size: 16,
                    background: Colors.transparent,
                    color: accentColor,
                    padding: 0,
                    radius: 8,
                    onTap: () => null,
                  ),
                  Text(
                    widget.folder,
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Dialogs {
  static showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomAlert(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 15),
              Text(
                "Player",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Are you sure you want to quit?",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 130,
                    child: OutlinedButton(
                      child: Text(
                        "No",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        side: MaterialStateProperty.all(
                          BorderSide(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 130,
                    child: ElevatedButton(
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => exit(0),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).accentColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

}


class CustomAlert extends StatelessWidget {
  final Widget child;

  CustomAlert({Key? key, required this.child}) : super(key: key);

  double deviceWidth = 0.0;
  double deviceHeight = 0.0;
  double dialogHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size screenSize = MediaQuery.of(context).size;

    deviceWidth = orientation == Orientation.portrait
        ? screenSize.width
        : screenSize.height;
    deviceHeight = orientation == Orientation.portrait
        ? screenSize.height
        : screenSize.width;
    dialogHeight = deviceHeight * (0.50);

    return MediaQuery(
      data: MediaQueryData(),
      child: GestureDetector(
//        onTap: ()=>Navigator.pop(context),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 0.5,
            sigmaY: 0.5,
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: deviceWidth * 0.9,
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                              ),
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//
//
// class GenThumbnailImage extends StatefulWidget {
//   final ThumbnailRequest thumbnailRequest;
//
//   const GenThumbnailImage({Key? key, required this.thumbnailRequest}) : super(key: key);
//
//   @override
//   _GenThumbnailImageState createState() => _GenThumbnailImageState();
// }
//
// class _GenThumbnailImageState extends State<GenThumbnailImage> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ThumbnailResult>(
//       future: genThumbnail(widget.thumbnailRequest),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.hasData) {
//           final _image = snapshot.data.image;
//           final _width = snapshot.data.width;
//           final _height = snapshot.data.height;
//           final _dataSize = snapshot.data.dataSize;
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Center(
//                 child: Text(
//                     "Image ${widget.thumbnailRequest.thumbnailPath == null ? 'data size' : 'file size'}: $_dataSize, width:$_width, height:$_height"),
//               ),
//               Container(
//                 color: Colors.grey,
//                 height: 1.0,
//               ),
//               _image,
//             ],
//           );
//         } else if (snapshot.hasError) {
//           return Container(
//             padding: EdgeInsets.all(8.0),
//             color: Colors.red,
//             child: Text(
//               "Error:\n${snapshot.error.toString()}",
//             ),
//           );
//         } else {
//           return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                     "Generating the thumbnail for: ${widget.thumbnailRequest.video}..."),
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 CircularProgressIndicator(),
//               ]);
//         }
//       },
//     );
//   }
// }
//
//
// class ThumbnailResult {
//   final Image image;
//   final int dataSize;
//   final int height;
//   final int width;
//   const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
// }
//
// Future<ThumbnailResult> genThumbnail(ThumbnailRequest r) async {
//   //WidgetsFlutterBinding.ensureInitialized();
//   Uint8List bytes;
//   final Completer<ThumbnailResult> completer = Completer();
//   if (r.thumbnailPath != null) {
//     final thumbnailPath = await VideoThumbnail.thumbnailFile(
//         video: r.video,
//         thumbnailPath: r.thumbnailPath,
//         imageFormat: r.imageFormat,
//         maxHeight: r.maxHeight,
//         maxWidth: r.maxWidth,
//         timeMs: r.timeMs,
//         quality: r.quality);
//
//     print("thumbnail file is located: $thumbnailPath");
//
//     final file = File(thumbnailPath);
//     bytes = file.readAsBytesSync();
//   } else {
//     bytes = (await VideoThumbnail.thumbnailData(
//         video: r.video,
//         imageFormat: r.imageFormat,
//         maxHeight: r.maxHeight,
//         maxWidth: r.maxWidth,
//         timeMs: r.timeMs,
//         quality: r.quality))!;
//   }
//
//   int _imageDataSize = bytes.length;
//   print("image size: $_imageDataSize");
//
//   final _image = Image.memory(bytes);
//   _image.image
//       .resolve(ImageConfiguration())
//       .addListener(ImageStreamListener((ImageInfo info, bool _) {
//     completer.complete(ThumbnailResult(
//       image: _image,
//       dataSize: _imageDataSize,
//       height: info.image.height,
//       width: info.image.width,
//     ));
//   }));
//   return completer.future;
// }