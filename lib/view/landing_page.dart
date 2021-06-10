import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:player_app/misc/svg.dart';
import 'package:player_app/misc/colors.dart';
import 'package:player_app/provider/video_provider.dart';
import 'package:player_app/view/assets/widgets.dart';

import '../routes.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<String> extensions = [
    "video/flv",
    "video/mp4",
    "video/3gp",
    "video/mov",
    "video/avi",
    "video/wmv"
  ];
  late FolderModel myModel;

  @override
  void initState() {
    myModel = FolderModel();
    myModel.getHomeDirectory(false);
    super.initState();
  }


  @override
  void dispose() {
    myModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Expanded(
                // flex: 6,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: accentColor),
                        ),
                        const SizedBox(
                          width: 24.0,
                        ),
                        const Text(
                          "Player",
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w900,
                              fontSize: 36),
                        ),
                        const Spacer(),
                        SvgIcon(
                          icon: svg_.settings,
                          height: 32,
                          width: 32,
                          padding: 0,
                          radius: 8,
                          onTap: () {
                            // Navigator.pushNamed(context, Routes.FolderPage_);
                            myModel.getHomeDirectory(false);
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Expanded(
                      child: ChangeNotifierProvider<FolderModel>(
                          create: (context) => myModel,
                          child: Consumer<FolderModel>(
                              builder: (context, myModel, child) {
                                print(myModel.folders.length);
                            return GridView.builder(
                              itemCount: myModel.folder.length,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0),
                              itemBuilder: (BuildContext context, int index) {
                                Folder single = myModel.folders[index];
                                return FolderData(
                                    folder_name: single.folderName!,
                                    root: single.rootPath!,
                                    folders: single.dirtCount!
                                );
                              },
                            );

                          })),
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   flex: 4,
              //   child: Container(
              //     margin: const EdgeInsets.only(bottom: 8.0),
              //     padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              //     decoration: BoxDecoration(
              //         color: white, borderRadius: BorderRadius.circular(10.0)),
              //     child: Column(
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             const Text(
              //               "Recent",
              //               style: TextStyle(
              //                   fontSize: 18, fontWeight: FontWeight.w800),
              //             ),
              //             TextButton(
              //               onPressed: () {},
              //               style: ButtonStyle(
              //                   shape: MaterialStateProperty.all<
              //                           RoundedRectangleBorder>(
              //                       RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(8.0),
              //               ))),
              //               child: Text("See All"),
              //             ),
              //           ],
              //         ),
              //         Expanded(
              //           child: GridView(
              //             physics: const BouncingScrollPhysics(),
              //             gridDelegate:
              //                 const SliverGridDelegateWithFixedCrossAxisCount(
              //                     crossAxisCount: 2,
              //                     crossAxisSpacing: 8.0,
              //                     childAspectRatio: 4 / 3,
              //                     mainAxisSpacing: 16.0),
              //             children: [
              //               RecentVideo(),
              //               RecentVideo(),
              //               RecentVideo(),
              //               RecentVideo(),
              //               RecentVideo(),
              //               RecentVideo()
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }


}

class FolderData extends StatelessWidget {
  final String? folder_name, root;//, files, folders;
  final int? folders;

  const FolderData(
      {Key? key,
      required this.folder_name,
      required this.root,
      required this.folders
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Folder fol = Folder(
      folderName: folder_name,
      rootPath: root,
      dirtCount: folders
    );
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, Routes.FolderPage_, arguments: {"folderData": fol});
      },
      child: Container(
        color: Colors.transparent,
        height: 70,
        width: 76,
        child: Column(
          children: [
            Stack(
              children: [
                SvgPicture.asset(
                  svg_.foldericon,
                  matchTextDirection: true,
                  color: white,
                  height: 70,
                  width: 76,
                ),
                // Positioned(
                //   top: 6,
                //   child: Column(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Row(
                //         children: [
                //           SvgIcon(
                //             icon: svg_.play,
                //             height: 32,
                //             width: 32,
                //             size: 16,
                //             background: Colors.transparent,
                //             color: accentColor,
                //             padding: 0,
                //             radius: 8,
                //             onTap: () => null,
                //           ),
                //           Text(
                //             files!,
                //             style: TextStyle(
                //                 fontSize: 16, fontWeight: FontWeight.w900),
                //           )
                //         ],
                //       ),
                //       Row(
                //         children: [
                //           SvgIcon(
                //             icon: svg_.folder,
                //             height: 32,
                //             width: 32,
                //             size: 16,
                //             background: Colors.transparent,
                //             color: accentColor,
                //             padding: 0,
                //             radius: 8,
                //             onTap: () => null,
                //           ),
                //           Text(
                //             folders!,
                //             style: TextStyle(
                //                 fontSize: 16, fontWeight: FontWeight.w900),
                //           )
                //         ],
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              folder_name!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}

class RecentVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Image.asset("asset/saly.png"),
        ),
        Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.1, 0.4],
              colors: [Colors.black45, Colors.transparent]),
          borderRadius: BorderRadius.circular(10.0),
        )),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Foldasdfasdfffffffffffffffffffffffffffffer name",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
              "20:20",
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500, color: white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
