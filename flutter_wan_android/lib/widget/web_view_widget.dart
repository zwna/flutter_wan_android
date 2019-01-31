import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewWidget extends StatefulWidget {

  final String urlLink;
  final String title;

  WebViewWidget({this.urlLink,this.title});

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState(urlLink,title);
}

class _WebViewWidgetState extends State<WebViewWidget> {

  String _urlLink;
  String _title;
  FlutterWebviewPlugin _flutterWebviewPlugin = FlutterWebviewPlugin();

  _WebViewWidgetState(this._urlLink,this._title);

  @override
  void initState() {
    super.initState();
    _flutterWebviewPlugin.onDestroy.listen((Null n){
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
          appBar:AppBar(
            title:Text(_title,style:TextStyle(fontSize:20.0,color:Colors.white)),
            backgroundColor:Colors.blue,
            centerTitle:true,
            elevation:0.0,
            actions: <Widget>[
              Container(
                margin:EdgeInsets.only(right:10.0),
                child:InkWell(
                  child:Icon(Icons.restore),
                  onTap:(){
                    _flutterWebviewPlugin.reload();
                  },
                ),
              )
            ],
          ),
          url:_urlLink,
          withZoom:true,
          enableAppScheme:true,
       );
  }
}
