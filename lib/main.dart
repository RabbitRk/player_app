import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:player_app/view/landing_page.dart';
import 'misc/colors.dart';
import 'package:player_app/routes.dart';
import 'misc/size_config.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraint, orientation);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: Routes.generateRoute,
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              primaryColor: Colors.deepOrange,
              canvasColor: scaffoldBackground,
              fontFamily: "RedHatDisplay",
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
          );
        });
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimeout() {
    return Timer(Duration(seconds: 2), handleTimeout);
  }

  void handleTimeout() {
    changeScreen();
  }

  changeScreen() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      requestPermission();
    } else {
      Navigator.pushNamed(context, Routes.LandingPage_);
    }
  }

  requestPermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      Navigator.pushNamed(context, Routes.LandingPage_);
    } else {
      //Dialog
    }
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Logo(size: 80,),
              Text("Player", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800, fontSize: 36),),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // void initState() {
  //   Future.delayed(new Duration(seconds: 1), (){
  //       Navigator.pushNamed(context, Routes.LandingPage_);
  //   });
  //   super.initState();
  // }
}