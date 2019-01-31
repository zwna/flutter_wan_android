import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_wan_android/utils/dio_utils.dart';
import 'package:flutter_wan_android/constant/net_url_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter_wan_android/bean/banner_bean.dart';
import 'package:flutter_wan_android/widget/search_widget.dart';
import 'package:flutter_wan_android/widget/web_view_widget.dart';
import 'package:flutter_wan_android/bean/home_page_article_bean.dart';
import 'package:flutter_wan_android/utils/toast_utils.dart';

class ZhuYeWidget extends StatefulWidget {
  @override
  _ZhuYeWidgetState createState() => _ZhuYeWidgetState();
}

class _ZhuYeWidgetState extends State<ZhuYeWidget> with AutomaticKeepAliveClientMixin{

  List<BannerItem> _bannerItemList = [];

  String _placeHolderImage = 'http://www.wanandroid.com/blogimgs/50c115c2-cf6c-4802-aa7b-a4334de444cd.png';

  String _bannerTitle = "一起来做个APP吧";

  int _currentPageNum = 0;
  int _totalPageNum = 0;

  bool _isLoading = true;
  bool _showOrHideOffstage = false;
  bool _isRefreshing = false;

  List<HomePageArticleDetailBean> _homePageArticleDetailBeanList = [];

  GlobalKey<RefreshIndicatorState> _globalKey = GlobalKey();
  ScrollController _scrollController = ScrollController(keepScrollOffset:false);



  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){///滚动到了底部
        setState(() {
          _showOrHideOffstage = false;
        });
        int _tempCurrentPageNum = _currentPageNum + 1;
        if(_tempCurrentPageNum > _totalPageNum - 1){
          ToastUtils.showShortToast('暂无更多数据');
          setState(() {
            _showOrHideOffstage = true;
          });
        }else {
          getArticleListData(_tempCurrentPageNum,null);
        }
      }
    });
    getBannerImagesUrl();
    getArticleListData(_currentPageNum,null);
  }

  getArticleListData(int pageNum,Completer complete) async{
    try {
      Response response = await DioUtils.getDioInstance().get(
          "${NetUrlConstant.homePageArticleUrl}$pageNum/json");
      var homePageArticleBean = HomePageArticleBean.fromJson(response.data);
      _totalPageNum = homePageArticleBean.data.pageCount;
      if(_isRefreshing){
        _currentPageNum = 0;
        _isRefreshing = false;
        complete?.complete();
      }
      setState(() {
        if(_isLoading) {
          _isLoading = false;
        }
        _showOrHideOffstage = true;
        _currentPageNum = _currentPageNum + 1;
        _homePageArticleDetailBeanList.addAll(homePageArticleBean.data.datas);
      });
    }on DioError catch(e){
      ToastUtils.showShortToast(e.message);
      setState(() {
        _showOrHideOffstage = true;
      });
    }
  }

  getBannerImagesUrl() async{
    try {
      Response response = await DioUtils.getDioInstance().get(
          NetUrlConstant.zhuYeBannerUrl);
      BannerBean bannerBean = BannerBean.fromJson(response.data);
      debugPrint(response.data.toString());
      setState(() {
        _bannerItemList.addAll(bannerBean.data);
      });
    }on DioError catch(e){
      ToastUtils.showShortToast(e.message);
    }
  }

  Future<Null> refreshHelper(){
     Completer<Null> completer = Completer();
       _isRefreshing = true;
       _bannerItemList.clear();
       _homePageArticleDetailBeanList.clear();
       getBannerImagesUrl();
       getArticleListData(0,completer);
       return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('主页',style:TextStyle(color:Colors.white,fontSize:20.0)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor:Colors.blue,
        actions:[
          Container(
            margin:EdgeInsets.only(right:10.0),
            child:InkWell(
              child:Icon(Icons.search),
              onTap:(){
                Navigator.of(context).push(MaterialPageRoute(
                    builder:(BuildContext context) => SearchWidget()
                )
                );
              },
            ),
          ),
        ],
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
      ):Container(
        child:RefreshIndicator(
            child:ListView.builder(
              key:_globalKey,
                controller:_scrollController,
                itemCount:_homePageArticleDetailBeanList.length + 1,
                itemBuilder:(BuildContext context,int index){
                  if(index == 0){
                    return Container(
                      height:150.0,
                      child:Stack(
                        children: <Widget>[
                          Swiper(
                            itemCount:_bannerItemList.length == 0 ? 1:_bannerItemList.length,
                            controller:SwiperController(),
                            pagination:SwiperPagination(
                                alignment:Alignment.bottomRight
                            ),
                            autoplay:true,
                            autoplayDelay: 3000,
                            scrollDirection: Axis.horizontal,
                            itemBuilder:(BuildContext context,int index){
                              return InkWell(
                                child:Image.network(_bannerItemList.length != 0 ? _bannerItemList[index].imagePath:_placeHolderImage,fit:BoxFit.fill),
                              );
                            },
                            onTap:(index){
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WebViewWidget(urlLink:_bannerItemList[index].url,title:_bannerTitle)));
                            },
                            onIndexChanged:(position){
                              setState(() {
                                _bannerTitle = _bannerItemList[position].title;
                              });
                            },
                          ),
                          Positioned(
                              left:10.0,
                              bottom:10.0,
                              child:Text(_bannerTitle,style:TextStyle(fontSize:12.0,color:Colors.blue)))
                        ],
                      ),
                    );
                  }else if(index == _homePageArticleDetailBeanList.length){
                    return Offstage(
                      offstage:_showOrHideOffstage,
                      child:SpinKitFadingCircle(
                        duration:Duration(seconds:2),
                        itemBuilder:(BuildContext context,int index){
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: index.isEven ? Colors.red : Colors.green,
                            ),
                          );
                        },
                      ),
                    );
                  }
                  else{
                    var homePageArticleDetailBean = _homePageArticleDetailBeanList[index - 1];
                    return Container(
                      child:Card(
                        elevation:5.0,
                        child:InkWell(
                          onTap:(){
                            Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context) => WebViewWidget(urlLink:homePageArticleDetailBean.link,title:homePageArticleDetailBean.title)));
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
                                      Container(
                                        margin:EdgeInsets.only(left:10.0,top:5.0),
                                        decoration:BoxDecoration(
                                          color:Colors.white,
                                          border:Border.all(color:Colors.blue,width:2.0),
                                          borderRadius:BorderRadius.all(Radius.circular(5.0)),
                                        ),
                                        child:Text(homePageArticleDetailBean.superChapterName,style:TextStyle(color:Colors.blue,fontSize:10.0)),
                                      ),
                                      Padding(
                                        padding:EdgeInsets.only(left:5.0),
                                        child:Text(homePageArticleDetailBean.author,style:TextStyle(fontSize:10.0,color:Colors.black)),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:EdgeInsets.only(right:5.0),
                                    child:Text("${DateTime.fromMillisecondsSinceEpoch(homePageArticleDetailBean.publishTime).year}-${DateTime.fromMillisecondsSinceEpoch(homePageArticleDetailBean.publishTime).month}-${DateTime.fromMillisecondsSinceEpoch(homePageArticleDetailBean.publishTime).day} ${DateTime.fromMillisecondsSinceEpoch(homePageArticleDetailBean.publishTime).hour}:${DateTime.fromMillisecondsSinceEpoch(homePageArticleDetailBean.publishTime).minute}:${DateTime.fromMillisecondsSinceEpoch(homePageArticleDetailBean.publishTime).second}",style:TextStyle(color:Colors.black,fontSize:10.0)),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding:EdgeInsets.only(top:8.0,left:8.0,right:8.0),
                                  child:Text(homePageArticleDetailBean.title,style:TextStyle(color:Colors.black,fontSize:15.0),maxLines:2,overflow:TextOverflow.ellipsis)
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left:8.0,right:8.0),
                                  child:Image.network(homePageArticleDetailBean.envelopePic.isEmpty ? "http://www.wanandroid.com/blogimgs/50c115c2-cf6c-4802-aa7b-a4334de444cd.png":homePageArticleDetailBean.envelopePic,fit:BoxFit.fill,width:50.0,height:80.0)
                              ),
                              Container(
                                alignment:Alignment.topLeft,
                                margin:EdgeInsets.only(left:5.0,top:5.0,bottom:5.0),
                                child:Text("${homePageArticleDetailBean.superChapterName}/${homePageArticleDetailBean.author}",style:TextStyle(color:Colors.black54,fontSize:12.0)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }), onRefresh:refreshHelper),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
