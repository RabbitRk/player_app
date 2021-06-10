import 'package:flutter/material.dart';
import 'package:player_app/view/folder_page.dart';
import 'package:player_app/view/landing_page.dart';
import 'package:player_app/view/player.dart';

import 'main.dart';
import 'misc/git.dart';
import 'misc/test.dart';

class Routes {
  //Route name constants
  static const String Root = '/';
  static const String CardDetail_ = 'detail';
  static const String DemoColor_ = 'demoscreen';
  static const String LandingPage_ = 'landingpage';
  static const String ContainerDemo_ = 'containerpage';
  static const String FolderPage_ = 'folderpage';
  static const String Player_ = 'playerpage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // print(settings);
    Map args = new Map();
    if (settings.arguments != null) {
      args = settings.arguments as Map<dynamic, dynamic>;
    }

    switch (settings.name) {
      case Root:
        return SlideBottomRoute(page: SplashScreen());
      case LandingPage_:
        return FadeRoute(page: LandingPage());
      case ContainerDemo_:
        return FadeRoute(page: OpenContainerTransformDemo());
      case FolderPage_:
        return FadeRoute(page: FolderPage(folder: args["folderData"],));
        case Player_:
        return FadeRoute(page: Player(url: args["url"]));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return const Scaffold(
        body: Center(
          child: Text("Error Route"),
        ),
      );
    });
  }
}
