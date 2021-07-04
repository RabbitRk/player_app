import 'package:better_player/better_player.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:player_app/misc/colors.dart';
import 'package:player_app/view/assets/face_detector.dart';

class Player extends StatefulWidget {
  final String url;

  const Player({Key? key, required this.url}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late BetterPlayerController _betterPlayerController;
  GlobalKey _betterPlayerKey = GlobalKey();
  late BetterPlayerDataSource dataSource;
  @override
  void initState() {
    BetterPlayerControlsConfiguration controlsConfiguration =
        const BetterPlayerControlsConfiguration(
      controlBarColor: Colors.black12,
      iconsColor: accentColor,
      playIcon: Icons.play_arrow,
      enablePip: true,
      progressBarPlayedColor: Colors.grey,
      progressBarHandleColor: accentColor,
      enableSkips: true,
      enableFullscreen: true,
      controlBarHeight: 40,
      loadingColor: Colors.red,
      overflowModalColor: white,
      overflowModalTextColor: black,
      overflowMenuIconsColor: accentColor,
    );

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
            aspectRatio: 16 / 9,
            fullScreenAspectRatio: 16 / 9,
            fit: BoxFit.fill,
            autoDetectFullscreenDeviceOrientation: true,
            controlsConfiguration: controlsConfiguration);
    dataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.file, widget.url);
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    _betterPlayerController.enterFullScreen();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }


  @override
  void dispose() {
    _betterPlayerController.stopPreCache(dataSource);
    super.dispose();
  } // FaceDetector faceDetector =
  // GoogleMlKit.vision.faceDetector(const FaceDetectorOptions(
  //   enableContours: true,
  //   enableLandmarks: true,
  //   enableClassification: true,
  // ));
  // bool isBusy = false;
  // CustomPaint? customPaint;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [

            Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: BetterPlayer(
                    key: _betterPlayerKey, controller: _betterPlayerController),
              ),
            )
            // ),Positioned(
            //   top: 24,
            //     left: 24,
            //     child: FittedBox(
            //       fit: BoxFit.fill,
            //         child: SizedBox(
            //           height: 60,
            //           width: 50,
            //           child: CameraView(
            //             title: 'Face Detector',
            //             customPaint: customPaint,
            //             onImage: (inputImage) {
            //               processImage(inputImage);
            //             },
            //             initialDirection: CameraLensDirection.front,
            //           ),
            //         ))),
          ],
        ),
      ),
    );
  }



  // Future<void> processImage(InputImage inputImage) async {
  //   if (isBusy) return;
  //   isBusy = true;
  //   final faces = await faceDetector.processImage(inputImage);
  //
  //   print('Found ${faces.length} faces');
  //
  //   if (inputImage.inputImageData?.size != null &&
  //       inputImage.inputImageData?.imageRotation != null) {
  //     final painter = FaceDetectorPainter(
  //         faces,
  //         inputImage.inputImageData!.size,
  //         inputImage.inputImageData!.imageRotation);
  //     customPaint = CustomPaint(painter: painter);
  //   } else {
  //     customPaint = null;
  //   }
  //   isBusy = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

}
/**
 * AspectRatio(
    aspectRatio: 16 / 9,
    child: BetterPlayer(
    key: _betterPlayerKey, controller: _betterPlayerController),
    )
 */
