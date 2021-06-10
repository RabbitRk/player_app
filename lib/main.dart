import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'misc/colors.dart';
import 'package:player_app/routes.dart';
import 'misc/size_config.dart';

void main() {
  runApp(const MyApp());
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
            themeMode: ThemeMode.dark,
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              brightness: Brightness.light,
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
      //Dialogs.showToast('Please grant storage permissions');
    }
  }

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIOverlays([]);
    startTimeout();
    // SchedulerBinding.instance!.addPostFrameCallback((_) {
    //   SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: scaffoldBackground,
    //     systemNavigationBarColor: scaffoldBackground,
    //     statusBarIconBrightness: Brightness.dark
    //     // Theme.of(context).primaryColor == ThemeConfig.darkTheme.primaryColor
    //     //     ? Brightness.light
    //     //     : Brightness.dark,
    //   ));
    // });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: scaffoldBackground,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlutterLogo(),
            Text("Player", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800, fontSize: 36),),
          ],
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