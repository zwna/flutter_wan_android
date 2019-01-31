import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_wan_android/widget/main_widget.dart';
import 'package:flutter_wan_android/utils/system_chrome_utils.dart';

void main() => runApp(
    MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashWidget(),
)
);

class SplashWidget extends StatefulWidget {
  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {

  Timer _timer;

  @override
  void initState() {
    super.initState();
    SystemChromeUtils.setFullScreen();
    _timer = Timer(Duration(seconds:3), (){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(BuildContext context) => MainWidget()), (Route route) => route == null);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Image.asset('images/splash.jpg',fit: BoxFit.fill),
    );
  }
}


