

import 'package:flutter/services.dart';

class SystemChromeUtils{

  ///设置全屏
  static setFullScreen(){
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
  
  ///显示状态栏和底部导航栏
  static showStatusBarAndBottomNavigationBar(){
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top,SystemUiOverlay.bottom]);
  }
}