import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {

  final routeName = 'splashscreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('asset/videos/logo.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller.play();
        setState(() {});
        Future.delayed(const Duration(milliseconds: 2500), () {
          setState(() {
            Navigator.popAndPushNamed(context, SignIn.routeName);
          });

        });
      });

    // TODO: implement initState

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      body:  Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(),
      ),

    );
  }
}
