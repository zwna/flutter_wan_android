
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/widget/about_me_widget.dart';

class GeRenZhongXinWidget extends StatefulWidget {
  @override
  _GeRenZhongXinWidgetState createState() => _GeRenZhongXinWidgetState();
}

class _GeRenZhongXinWidgetState extends State<GeRenZhongXinWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('个人中心',style:TextStyle(color:Colors.white,fontSize:20.0)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor:Colors.blue,
      ),
      body:Container(
        child:Column(
          children: <Widget>[
            Container(
              height:200.0,
              child:Stack(
                alignment:Alignment.center,
                children: <Widget>[
                  Image.network('http://pic170.nipic.com/file/20180629/24903911_111202018080_2.jpg',fit:BoxFit.fill,width:double.infinity,height:200.0),
                  Positioned(
                    child:CircleAvatar(
                      backgroundImage:NetworkImage('http://pic20.photophoto.cn/20110902/0020033018777780_b.jpg'),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading:Icon(Icons.info),
              title:Text('关于我',style:TextStyle(color:Colors.black,fontSize:13.0)),
              trailing:Icon(Icons.chevron_right),
              onTap:(){
                 Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context) => AboutMeWidget()));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
