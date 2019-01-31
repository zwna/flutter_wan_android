
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutMeWidget extends StatelessWidget {

  static const _platform = const MethodChannel('flutter_dialog_plugin');

  _showYuanShengDialog(){
    if(Platform.isAndroid) {
//      _platform.invokeMethod('tip');
//      _platform.invokeMethod('pop');
      _platform.invokeMethod('dialog');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('关于我',style:TextStyle(color:Colors.white,fontSize:20.0)),
        centerTitle:true,
        elevation:0.0,
        backgroundColor:Colors.blue,
      ),
      body:Center(
        child:InkWell(
          child:Image.asset('images/code.jpg',fit:BoxFit.fill),
          onTap:(){
//            showDialog(context: context,barrierDismissible:true,builder:(BuildContext context){
//              return  SimpleDialog(
//                title:Text('请选择要分享的内容',style:TextStyle(color:Colors.black,fontSize:15.0)),
//                children: <Widget>[
//                  SimpleDialogOption(child:Text('文本',style:TextStyle(color:Colors.black,fontSize:12.0)),onPressed:(){
//                    Navigator.pop(context);
//                  }),
//                  SimpleDialogOption(child:Text('二维码图片',style:TextStyle(color:Colors.black,fontSize:12.0)),onPressed:(){
//                    Navigator.pop(context);
//                  }),
//                ],
//              );
//            });
          _showYuanShengDialog();
          },
        ),
      ),
    );
  }
}
