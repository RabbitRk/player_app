import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player_app/misc/colors.dart';

class Player extends StatefulWidget {
  final String url;

  const Player({Key? key, required this.url}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late BetterPlayerController _betterPlayerController;
  GlobalKey _betterPlayerKey = GlobalKey();

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
    BetterPlayerDataSource dataSource =
        BetterPlayerDataSource(BetterPlayerDataSourceType.file, widget.url);
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    _betterPlayerController.enterFullScreen();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(
              key: _betterPlayerKey, controller: _betterPlayerController),
        ),
      ),
    );
  }
}
