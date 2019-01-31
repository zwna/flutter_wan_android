
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_wan_android/utils/dio_utils.dart';
import 'package:flutter_wan_android/constant/net_url_constant.dart';
import 'package:flutter_wan_android/bean/search_article_nean.dart';
import 'package:flutter_wan_android/widget/web_view_widget.dart';

class SearchResultWidget extends StatefulWidget {

  final String searchContent;

  const SearchResultWidget(this.searchContent);

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState(searchContent);
}

class _SearchResultWidgetState extends State<SearchResultWidget> {

  String _searchContent;

  int _currentPage = 0;
  
  ///是否正在加载数据 true:正在加载数据 false:数据加载完成
  bool _isLoading = true;
  List<SearchArticleDetailBean> _searchArticleDetailBean = List();

  _SearchResultWidgetState(_searchResult){
      _searchContent = _searchResult;
  }

  @override
  void initState() {
    super.initState();
    _getSearchResult();
  }

  _getSearchResult() async{
    FormData formData = FormData.from({"k":_searchContent});
    Response response = await DioUtils.getDioInstance().post("${NetUrlConstant.searchResultUrl}$_currentPage/json",data:formData);
    var searchArticleBean = SearchArticleBean.fromJson(response.data);
    debugPrint(response.data.toString());
    setState(() {
      _searchArticleDetailBean.addAll(searchArticleBean.data.datas);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text(_searchContent == null ? '':_searchContent,style:TextStyle(color:Colors.white,fontSize:20.0)),
        elevation: 0.0,
        backgroundColor:Colors.blue,
        centerTitle:true,
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
      ) : _searchArticleDetailBean.length == 0 ? Center(
        child:Text('没有数据',style:TextStyle(fontSize:15.0,color:Colors.black)),
      ): Container(
        child:ListView(
            children:_searchArticleDetailBean.map((_searchArticleDetailBean){
              return Container(
                child:Card(
                  elevation:5.0,
                  child:InkWell(
                    onTap:(){
                      Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context) => WebViewWidget(urlLink:_searchArticleDetailBean.link,title:_searchArticleDetailBean.title)));
                    },
                    child:Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin:EdgeInsets.only(left:10.0,top:5.0),
                                  decoration:BoxDecoration(
                                    color:Colors.white,
                                    border:Border.all(color:Colors.blue,width:2.0),
                                    borderRadius:BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child:Text(_searchArticleDetailBean.superChapterName,style:TextStyle(color:Colors.blue,fontSize:10.0)),
                                ),
                                Padding(
                                  padding:EdgeInsets.only(left:5.0),
                                  child:Text(_searchArticleDetailBean.author,style:TextStyle(fontSize:10.0,color:Colors.black)),
                                ),
                              ],
                            ),
                            Padding(
                              padding:EdgeInsets.only(right:5.0),
                              child:Text("${DateTime.fromMillisecondsSinceEpoch(_searchArticleDetailBean.publishTime).year}-${DateTime.fromMillisecondsSinceEpoch(_searchArticleDetailBean.publishTime).month}-${DateTime.fromMillisecondsSinceEpoch(_searchArticleDetailBean.publishTime).day} ${DateTime.fromMillisecondsSinceEpoch(_searchArticleDetailBean.publishTime).hour}:${DateTime.fromMillisecondsSinceEpoch(_searchArticleDetailBean.publishTime).minute}:${DateTime.fromMillisecondsSinceEpoch(_searchArticleDetailBean.publishTime).second}",style:TextStyle(color:Colors.black,fontSize:10.0)),
                            ),
                          ],
                        ),
                        Wrap(
                          children: <Widget>[
                            Padding(
                                padding:EdgeInsets.only(top:8.0,left:8.0,right:8.0),
                                child:Text(_searchArticleDetailBean.title,style:TextStyle(color:Colors.black,fontSize:15.0),maxLines:2,overflow:TextOverflow.ellipsis)
                            ),
                            Padding(padding: EdgeInsets.only(left:8.0,right:8.0),
                                child:Image.network(_searchArticleDetailBean.envelopePic.isEmpty ? "http://www.wanandroid.com/blogimgs/50c115c2-cf6c-4802-aa7b-a4334de444cd.png":_searchArticleDetailBean.envelopePic,fit:BoxFit.fill,width:50.0,height:80.0))
                          ],
                        ),
                        Container(
                          alignment:Alignment.topLeft,
                          margin:EdgeInsets.only(left:5.0,top:5.0,bottom:5.0),
                          child:Text("${_searchArticleDetailBean.superChapterName}/${_searchArticleDetailBean.author}",style:TextStyle(color:Colors.black54,fontSize:12.0)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList()),
      )
    );
  }
}
