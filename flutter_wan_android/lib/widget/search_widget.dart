
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/utils/dio_utils.dart';
import 'package:flutter_wan_android/constant/net_url_constant.dart';
import 'package:flutter_wan_android/bean/hot_key.dart';
import 'package:flutter_wan_android/bean/hot_key.dart';
import 'package:flutter_wan_android/widget/search_result_widget.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  TextEditingController _textEditingController;
  GlobalKey<ScaffoldState> _globalKey;
  List<Data> _dataList;

  _clickSearch(String text){
    if(text.length == 0){
      _globalKey.currentState.showSnackBar( SnackBar(
          content: Text('请输入搜索内容',style:TextStyle(color:Colors.white)),
          backgroundColor:Colors.red,
          action:SnackBarAction(label:'确定', onPressed:(){})
      ));
    }else{
      Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context) => SearchResultWidget(_textEditingController.text.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _globalKey = GlobalKey();
    _dataList = List();

    getHotKeyData();

  }

  getHotKeyData() async{
    Response response = await DioUtils.getDioInstance().get(NetUrlConstant.hotKeyUrl);
    var data = response.data;
    if(data != null){
      var hotKey = HotKey.fromJson(response.data);
      setState(() {
        _dataList.addAll(hotKey.data);
      });
      debugPrint(hotKey.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_globalKey,
      appBar:AppBar(
        title: Container(
          width:200.0,
          margin:EdgeInsets.only(right:30.0),
          child:TextField(
            controller:_textEditingController,
            style:TextStyle(
              color:Colors.white,
              fontSize:15.0,
            ),
            onSubmitted:(text){
              _clickSearch(text);
            },
            cursorColor:Colors.white,
            decoration:InputDecoration(
              border:InputBorder.none,
              hintText:'发现更多干货',
              hintStyle:TextStyle(
                color:Colors.white70,
                fontSize:10.0
              )
            ),
          ),
        ),
        centerTitle:true,
        elevation: 0.0,
        actions: <Widget>[
          Container(
            margin:EdgeInsets.only(right:10.0),
            child:InkWell(
              child:Icon(Icons.search),
              onTap:(){
                _clickSearch(_textEditingController.text);
              },
            ),
          ),
          Container(
            margin:EdgeInsets.only(right:20.0),
            child:InkWell(
              child:Icon(Icons.close),
              onTap:(){
                _textEditingController.clear();
              },
            ),
          ),
        ],
      ),
      body:Container(
        child:Column(
          children: <Widget>[
            Container(
              alignment:Alignment.centerLeft,
              margin:EdgeInsets.only(top:10.0,left:15.0),
              child:Text('热搜',style:TextStyle(fontSize:16.0,color:Colors.blue)),
            ),
            Container(
              alignment:Alignment.centerLeft,
              margin:EdgeInsets.only(top:10.0,left:15.0),
              child:Wrap(
                spacing:10.0,
                children:
                  _dataList.map((data){
                        return ActionChip(
                          avatar:CircleAvatar(
                            child:Icon(Icons.close),
                          ),
                          label:Text(data.name,style:TextStyle(fontSize:12.0,color:Colors.white)),
                          onPressed:(){
                             Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context) => SearchResultWidget(data.name)));
                          },
                          backgroundColor:Colors.blue,
                          tooltip:data.name,
                        );
                  }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
