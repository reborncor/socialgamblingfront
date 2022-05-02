import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';
import 'package:socialgamblingfront/tab/TabView.dart';
import 'package:socialgamblingfront/util/util.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {

  final routeName = 'splashscreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  bool isUserLogged = false;
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
      ..initialize().then((_)  async {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller.play();
        setState(() {});
        Future.delayed(const Duration(milliseconds: 2500), () {

          setState(() {
            if(this.isUserLogged){
              Navigator.pushReplacementNamed(context, TabView.routeName);
            }
            else{
              Navigator.pushReplacementNamed(context, SignIn.routeName);
            }

          });

        });
      });

  }
  fetchData() async {
    String data = await getCurrentUserToken();
    if (data != null && data.isNotEmpty ){
      log("ACCESS GRANTED");
      this.isUserLogged = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchData();
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
