
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_wan_android/bean/knowledge_system_bean.dart';
import 'package:flutter_wan_android/utils/dio_utils.dart';
import 'package:flutter_wan_android/bean/specific_knowledge_bean.dart';
import 'package:flutter_wan_android/constant/net_url_constant.dart';
import 'package:flutter_wan_android/utils/toast_utils.dart';
import 'package:flutter_wan_android/widget/web_view_widget.dart';

class KnowledgeSystemDetailWidget extends StatefulWidget {

  final String title;
  final int index;
  final List<KnowledgeSystemPartDetailBean> knowledgeSystemPartDetailBeanList;

  KnowledgeSystemDetailWidget(this.title,this.index,this.knowledgeSystemPartDetailBeanList);

  @override
  _KnowledgeSystemDetailWidgetState createState() => _KnowledgeSystemDetailWidgetState(this.title,this.index,this.knowledgeSystemPartDetailBeanList);
}

class _KnowledgeSystemDetailWidgetState extends State<KnowledgeSystemDetailWidget> {

  String _title;
  int _index;
  List<KnowledgeSystemPartDetailBean> _knowledgeSystemPartDetailBeanList;

  _KnowledgeSystemDetailWidgetState(this._title,this._index,this._knowledgeSystemPartDetailBeanList);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:_knowledgeSystemPartDetailBeanList.length,
      initialIndex:_index,
      child: Scaffold(
        appBar:AppBar(
          title:Text(_title,style:TextStyle(color:Colors.white,fontSize:20.0)),
          centerTitle:true,
          backgroundColor:Colors.blue,
          elevation:0.0,
          bottom:TabBar(
            isScrollable:true,
            indicatorColor:Colors.white,
            indicatorWeight:3.0,
            tabs:_knowledgeSystemPartDetailBeanList.map((_knowledgeSystemPartDetailBean){
              return Container(
                padding:EdgeInsets.all(8.0),
                child:Text(_knowledgeSystemPartDetailBean.name,style:TextStyle(color:Colors.white,fontSize:15.0)),
              );
            }).toList(),
          ),
        ),
        body:TabBarView(
            children:_knowledgeSystemPartDetailBeanList.map((_knowledgeSystemPartDetailBean){
              return ListPageView(_knowledgeSystemPartDetailBean.id.toString());
            }).toList()
        ),
      ),
    );
  }
}

class ListPageView extends StatefulWidget {

  final String cid;

  ListPageView(this.cid);

  @override
  _ListPageViewState createState() => _ListPageViewState(this.cid);
}

class _ListPageViewState extends State<ListPageView> {

  String _cid;

  List<SpecificKnowledgeDetailBean> _specificKnowledgeDetailBean = [];

  bool _isLoading = true;

  _ListPageViewState(this._cid);

  @override
  void initState() {
    super.initState();
    getKnowledgeSystemDetailData();
  }

  getKnowledgeSystemDetailData()async{
    try {
      Response response = await DioUtils.getDioInstance().get(
          NetUrlConstant.knowledgeSystemDetailUrl, data: {"cid": _cid});
      var specificKnowledgeBean = SpecificKnowledgeBean.fromJson(response.data);
      setState(() {
        _specificKnowledgeDetailBean.addAll(specificKnowledgeBean.data.datas);
        _isLoading = false;
      });
    } on DioError catch(e){
      ToastUtils.showShortToast(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? SpinKitFadingCircle(
      duration:Duration(seconds:2),
      itemBuilder:(BuildContext context,int index){
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    ):PageView.builder(
      physics:NeverScrollableScrollPhysics(),
        itemCount:_specificKnowledgeDetailBean.length,
        itemBuilder:(BuildContext context,int index){
          return ListView(
            children:_specificKnowledgeDetailBean.map((_specificKnowledgeDetailBean){
              return Container(
                margin:EdgeInsets.only(top:8.0,bottom:8.0),
                child:Card(
                  elevation:5.0,
                  child:InkWell(
                    onTap:(){
                      Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context) => WebViewWidget(urlLink:_specificKnowledgeDetailBean.link,title:_specificKnowledgeDetailBean.title)));
                    },
                    child:Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:EdgeInsets.only(left:5.0,top:5.0),
                                  child:Text(_specificKnowledgeDetailBean.author,style:TextStyle(fontSize:15.0,color:Colors.black)),
                                ),
                              ],
                            ),
                            Padding(
                              padding:EdgeInsets.only(right:5.0,top:5.0),
                              child:Text("${DateTime.fromMillisecondsSinceEpoch(_specificKnowledgeDetailBean.publishTime).year}-${DateTime.fromMillisecondsSinceEpoch(_specificKnowledgeDetailBean.publishTime).month}-${DateTime.fromMillisecondsSinceEpoch(_specificKnowledgeDetailBean.publishTime).day} ${DateTime.fromMillisecondsSinceEpoch(_specificKnowledgeDetailBean.publishTime).hour}:${DateTime.fromMillisecondsSinceEpoch(_specificKnowledgeDetailBean.publishTime).minute}:${DateTime.fromMillisecondsSinceEpoch(_specificKnowledgeDetailBean.publishTime).second}",style:TextStyle(color:Colors.black,fontSize:15.0)),
                            ),
                          ],
                        ),
                            Padding(
                                padding:EdgeInsets.only(top:8.0,left:8.0,right:8.0),
                                child:Text(_specificKnowledgeDetailBean.title,style:TextStyle(color:Colors.black,fontSize:15.0),maxLines:2,overflow:TextOverflow.ellipsis)
                            ),
                            Padding(padding: EdgeInsets.only(left:8.0,right:8.0),
                                child:Image.network(_specificKnowledgeDetailBean.envelopePic.isEmpty ? "http://www.wanandroid.com/blogimgs/50c115c2-cf6c-4802-aa7b-a4334de444cd.png":_specificKnowledgeDetailBean.envelopePic,fit:BoxFit.fill,width:50.0,height:80.0)
                            ),
                        Container(
                          alignment:Alignment.topLeft,
                          margin:EdgeInsets.only(left:5.0,top:5.0,bottom:5.0),
                          child:Text("${_specificKnowledgeDetailBean.superChapterName}/${_specificKnowledgeDetailBean.author}",style:TextStyle(color:Colors.black54,fontSize:12.0)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        });
  }
}

