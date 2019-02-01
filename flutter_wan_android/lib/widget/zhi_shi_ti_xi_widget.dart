
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_wan_android/constant/net_url_constant.dart';
import 'package:flutter_wan_android/utils/dio_utils.dart';
import 'package:flutter_wan_android/utils/toast_utils.dart';
import 'package:flutter_wan_android/bean/knowledge_system_bean.dart';
import 'package:flutter_wan_android/widget/knowledge_system_detail_widget.dart';


class ZhiShiTiXiWidget extends StatefulWidget {
  @override
  _ZhiShiTiXiWidgetState createState() => _ZhiShiTiXiWidgetState();
}

class _ZhiShiTiXiWidgetState extends State<ZhiShiTiXiWidget> with AutomaticKeepAliveClientMixin{
  
  bool _isLoading = true;
  
  List<KnowledgeSystemPartBean> _knowledgeSystemPartBeanList = [];
  List<KnowledgeSystemPartDetailBean> _knowledgeSystemPartDetailBeanList = [];

  @override
  void initState() {
    super.initState();
    getKnowledgeSystemData();
  }

  getKnowledgeSystemData() async{
    try {
      Response response = await DioUtils.getDioInstance().get(NetUrlConstant.knowledgeSystemUrl);
      var knowledgeSystemBean = KnowledgeSystemBean.fromJson(response.data);
      setState(() {
        _knowledgeSystemPartBeanList.addAll(knowledgeSystemBean.data);
        _isLoading = false;
      });
    }on DioError catch(e){
      ToastUtils.showShortToast(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('知识体系',style:TextStyle(color:Colors.white,fontSize:20.0)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor:Colors.blue,
      ),
      body:_isLoading ? SpinKitFadingCircle(
        duration:Duration(seconds:2),
        itemBuilder:(BuildContext context,int index){
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.red : Colors.green,
            ),
          );
        },
      ):_knowledgeSystemPartBeanList.length != 0 ? ListView(
        children:_knowledgeSystemPartBeanList.map((_knowledgeSystemPartBean){
          return Container(
            margin:EdgeInsets.all(5.0),
            child:Card(
              elevation:3.0,
              child:Container(
                margin:EdgeInsets.all(5.0),
                child:Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_knowledgeSystemPartBean.name,style:TextStyle(color:Colors.black,fontSize:15.0)),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                    Container(
                      margin:EdgeInsets.only(top:18.0),
                      child:Wrap(
                        spacing:8.0,
                        runSpacing:15.0,
                        children:_knowledgeSystemPartBean.children.map((_knowledgeSystemPartDetailBean){
                          return GestureDetector(
                            child:Baseline(
                              baseline: 1.0,
                              baselineType: TextBaseline.alphabetic,
                              child:Text(_knowledgeSystemPartDetailBean.name,style:TextStyle(color:Colors.blue,fontSize:15.0,fontWeight:FontWeight.bold,decoration:TextDecoration.underline)),),
                            onTap:(){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder:(BuildContext context) => KnowledgeSystemDetailWidget(_knowledgeSystemPartBean.name, _knowledgeSystemPartBean.children.indexOf(_knowledgeSystemPartDetailBean),_knowledgeSystemPartBean.children)
                              ));
                            },
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ):Center(
        child:Text("没有数据",style:TextStyle(color:Colors.black,fontSize:15.0)),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
