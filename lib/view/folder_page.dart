import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:player_app/misc/colors.dart';
import 'package:player_app/provider/video_provider.dart';

import '../routes.dart';
import 'assets/widgets.dart';
import 'package:player_app/misc/svg.dart';

class FolderPage extends StatefulWidget {
  final Folder folder;

  const FolderPage({Key? key, required this.folder}) : super(key: key);

  @override
  _FolderPageState createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  SubFolderModel subModel = SubFolderModel();
  List<String> roots = [];

  @override
  Widget build(BuildContext context) {
    roots.add(widget.folder.rootPath!);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          SizedBox(
            height: 52,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.01),
                          offset: const Offset(
                            0.0,
                            0.0,
                          ),
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                        ), //BoxS //BoxShadow
                      ]),
                  child: SvgIcon(
                    icon: svg_.chevron_left,
                    height: 32,
                    width: 32,
                    padding: 4,
                    size: 14,
                    color: black,
                    background: white,
                    radius: 32,
                    onTap: () {},
                  ),
                ),
                const SizedBox(
                  width: 24.0,
                ),
                const Text(
                  "Player",
                  style: TextStyle(
                      color: black, fontWeight: FontWeight.w900, fontSize: 24),
                ),
                const Spacer(),
                SvgIcon(
                  icon: svg_.settings,
                  height: 32,
                  width: 32,
                  padding: 0,
                  radius: 8,
                  onTap: () {},
                )
              ],
            ),
          ),
          ChangeNotifierProvider<SubFolderModel>(
              create: (context) => subModel,
              child:
                  Consumer<SubFolderModel>(builder: (context, myModel, child) {
                return FolderDetail(
                    folder: myModel.folder_element.length.toString(),
                    file: myModel.file_element.length.toString(),
                    folder_name: widget.folder.folderName!);
              })),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                  color: white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Files",
                    style: TextStyle(
                        fontSize: 18,
                        color: accentColor,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ChangeNotifierProvider<SubFolderModel>(
                      create: (context) => subModel,
                      child: Consumer<SubFolderModel>(
                          builder: (context, myModel, child) {
                        //Folder and file data
                        List<Widget> folder =
                            folder_data(myModel.folder_element);
                        List<Widget> files = file_data(myModel.file_element);

                        folder.addAll(files);

                        return Expanded(
                          child: ListView(children: folder),
                        );
                      })),
                ],
              ),
            ),
          ),
        ],
      ),
    )));
  }

  List<Widget> folder_data(List<FolderElement> folder) {
    return List.generate(
        folder.length,
        (index) => GestureDetector(
              onTap: () {
                roots.add(folder[index].rootPath!);
                subModel.getSubDirectory(false, folder[index].rootPath!);
              },
              child: Container(
                color: white,
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        svg_.foldericon,
                        matchTextDirection: true,
                        height: 54,
                        width: 66,
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Text(
                          folder[index].folderName!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      )
                    ]),
              ),
            ));
  }

  List<Widget> file_data(List<FileElement> folder_element) {
    var asset;
    return List.generate(
        folder_element.length,
        (index) => GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.Player_,
                        arguments: {"url": folder_element[index].filePath})
                    .whenComplete(() {
                  setState(() {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]);
                  });
                });
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      height: 90,
                      width: 160,
                      decoration: BoxDecoration(
                          color: black,
                          borderRadius: BorderRadius.circular(8)),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: folder_element[index].thumbnail == null
                                ? Image.file(File(""))
                                : Image.file(File(
                                    folder_element[index].thumbnail ?? "")),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: const EdgeInsets.all(2.0),
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: Text(
                                folder_element[index].duration!,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          folder_element[index].fileName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          folder_element[index].filesize!,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ));
  }

  @override
  void initState() {
    subModel = new SubFolderModel();
    subModel.getSubDirectory(false, widget.folder.rootPath!);
    super.initState();
  }
}
/*
*
* AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer.network(
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
          betterPlayerConfiguration: BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
          ),
        ),
      )
      *
      *
      */
// Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: [
//          Text(
//            "Files",
//            style: TextStyle(
//                fontSize: 18,
//                color: accentColor,
//                fontWeight: FontWeight.w800),
//          ),
//          SizedBox(
//            height: 16.0,
//          ),
//          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//            SvgPicture.asset(
//              svg_.foldericon,
//              matchTextDirection: true,
//              height: 54,
//              width: 66,
//            ),
//            SizedBox(
//              width: 16.0,
//            ),
//            Text(
//              "Folders name",
//              style:
//                  TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//            )
//          ]),
//          SizedBox(
//            height: 16.0,
//          ),
//          Row(children: [
//            Container(
//              height: 54,
//              width: 60,
//              decoration: BoxDecoration(
//                  color: Colors.red,
//                  borderRadius: BorderRadius.circular(8)),
//              child: Image.asset("asset/saly.png"),
//            ),
//            SizedBox(
//              width: 16.0,
//            ),
//            Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: [
//                Text(
//                  "Folders name",
//                  style: TextStyle(
//                      fontSize: 16, fontWeight: FontWeight.w500),
//                ),
//                SizedBox(
//                  height: 8.0,
//                ),
//                Text(
//                  "220 MB",
//                  style: TextStyle(
//                      fontSize: 14, fontWeight: FontWeight.w800),
//                ),
//              ],
//            )
//          ])
//        ],
//      ),
/* */

// ListView.builder(
//     shrinkWrap: true,
//     physics: const BouncingScrollPhysics(),
//     itemCount: myModel.folder_element.length,
//     itemBuilder: (BuildContext context, int index) {
//
//       FolderElement fol = myModel.folder_element[index];
//
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 8.0),
//         child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           SvgPicture.asset(
//             svg_.foldericon,
//             matchTextDirection: true,
//             height: 54,
//             width: 66,
//           ),
//           const SizedBox(
//             width: 16.0,
//           ),
//           Expanded(
//             child: Text(
//               fol.folderName!,
//               style:
//               TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//           )
//         ]),
//       );
//     }),

// ListView.builder(
//     shrinkWrap: true,
//     physics: const BouncingScrollPhysics(),
//     itemCount: myModel.file_element.length,
//     itemBuilder: (BuildContext context, int index) {
//       FileElement sele = myModel.file_element[index];
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 8.0),
//         child: Row(children: [
//           Container(
//             height: 90,
//             width: 160,
//             decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius:
//                 BorderRadius.circular(8)),
//             child: Image.asset("asset/saly.png"),
//           ),
//           const SizedBox(
//             width: 16.0,
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//               CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   sele.fileName,
//                   style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(
//                   height: 8.0,
//                 ),
//                 const Text(
//                   "220 MB",
//                   style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w800),
//                 ),
//               ],
//             ),
//           )
//         ]),
//       );
//     })
