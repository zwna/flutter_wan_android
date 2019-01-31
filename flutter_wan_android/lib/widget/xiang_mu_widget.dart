
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_wan_android/utils/dio_utils.dart';
import 'package:flutter_wan_android/constant/net_url_constant.dart';
import 'package:flutter_wan_android/bean/project_module_bean.dart';
import 'package:flutter_wan_android/utils/toast_utils.dart';
import 'package:flutter_wan_android/bean/project_list_bean.dart';
import 'package:flutter_wan_android/utils/date_time_utils.dart';
import 'dart:ui';
import 'package:flutter_wan_android/widget/web_view_widget.dart';

class XiangMuWidget extends StatefulWidget {
  @override
  _XiangMuWidgetState createState() => _XiangMuWidgetState();
}

class _XiangMuWidgetState extends State<XiangMuWidget>with AutomaticKeepAliveClientMixin {

  List<ProjectModuleDetailBean> _projectModuleDetailBean = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getTabData();
  }

  _getTabData() async{
    try {
      Response response = await DioUtils.getDioInstance().get(NetUrlConstant.projectModuleUrl);
      ProjectModuleBean projectModuleBean = ProjectModuleBean.fromJson(response.data);
      setState(() {
        _isLoading = false;
        _projectModuleDetailBean.addAll(projectModuleBean.data);
      });
    } on DioError catch (e) {
     ToastUtils.showShortToast(e.message);
    }

  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ?  SpinKitFadingCircle(
      duration:Duration(seconds:2),
      itemBuilder:(BuildContext context,int index){
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    ):DefaultTabController(
        length: _projectModuleDetailBean.length == 0 ? 1:_projectModuleDetailBean.length,
        initialIndex: 0,
        child: Scaffold(
          appBar:AppBar(
            title:Text('项目',style:TextStyle(color:Colors.white,fontSize:20.0)),
            centerTitle: true,
            elevation: 0.0,
            backgroundColor:Colors.blue,
            bottom:TabBar(
                isScrollable: true,
                tabs:_projectModuleDetailBean.map((_projectModuleDetailBean){
                  return Container(
                    padding:EdgeInsets.all(8.0),
                    child:Text(_projectModuleDetailBean.name,style:TextStyle(color:Colors.white,fontSize:15.0)),
                  );
                }
                ).toList()
            ),
          ),
          body:TabBarView(
              children:_projectModuleDetailBean.map((_projectModuleDetailBean){
                return ProjectPageView(_projectModuleDetailBean.id.toString());
              }).toList()
          ),
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProjectPageView extends StatefulWidget {

  final String _id;

  ProjectPageView(this._id);

  @override
  _ProjectPageViewState createState() => _ProjectPageViewState(this._id);
}

class _ProjectPageViewState extends State<ProjectPageView> with AutomaticKeepAliveClientMixin  {

  String _cid;

  ///当前数据的页数
  int _currentPageNumber = 0;
  ///数据的总页数
  int _totalPageNumber = 0;

  bool _isLoading = true;
  ///用户是否在加载更多
  bool _isLoadingMore = false;
  bool _showOrHideOffstage = true;

  ScrollController _scrollController = ScrollController(keepScrollOffset:false);

  List<ProjectListInfoDetailBean> _projectListInfoDetailBeanList = [];

  _ProjectPageViewState(this._cid);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){///滚动到底部
        setState(() {
          _showOrHideOffstage = false;
        });
        _isLoadingMore = true;
        int _tempCurrentPageNum = this._currentPageNumber + 1;
        if(_tempCurrentPageNum > _totalPageNumber - 1){
          ToastUtils.showShortToast("暂无更多数据");
          setState(() {
            _showOrHideOffstage = true;
          });
        }else {
          _getProjectModuleDetail(_tempCurrentPageNum);
        }
      }
    });
    _getProjectModuleDetail(this._currentPageNumber);
  }


  _getProjectModuleDetail(int _currentPageNumber) async{
    try {
      Response response = await DioUtils.getDioInstance().get("${NetUrlConstant.projectModuleListUrl}/$_currentPageNumber/json",data:{"cid":_cid});
      var projectListBean = ProjectListBean.fromJson(response.data);
      _totalPageNumber = projectListBean.data.pageCount;
      if(_isLoadingMore){
        this._currentPageNumber = this._currentPageNumber + 1;
      }
      setState(() {
        if(_isLoading) {
          _isLoading = false;
        }
        _projectListInfoDetailBeanList.addAll(projectListBean.data.datas);
        _isLoadingMore = false;
        _showOrHideOffstage = true;
      });
    } on DioError catch (e) {
      ToastUtils.showShortToast(e.message);
      setState(() {
        _showOrHideOffstage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ?  SpinKitFadingCircle(
      duration:Duration(seconds:2),
      itemBuilder:(BuildContext context,int index){
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    ): PageView(
           physics:NeverScrollableScrollPhysics(),
            children: <Widget>[
              ListView(
                controller:_scrollController,
                children:_projectListInfoDetailBeanList.map((_projectListInfoDetailBean){
                  if(_projectListInfoDetailBeanList.indexOf(_projectListInfoDetailBean) == _projectListInfoDetailBeanList.length - 1){
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
                  }else {
                    return Container(
                      height: 130.0,
                      margin: EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  WebViewWidget(
                                      urlLink: _projectListInfoDetailBean.link,
                                      title: _projectListInfoDetailBean
                                          .title)));
                        },
                        child: Card(
                          elevation: 3.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Material(
                                child: Image.network(
                                  _projectListInfoDetailBean.envelopePic,
                                  width: 80.0,
                                  height: 120.0,
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(2.0),
                                    bottomLeft: Radius.circular(2.0)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10.0, top: 8.0, right: 10.0),
                                    child: Text(
                                        _projectListInfoDetailBean.title,
                                        style: TextStyle(color: Colors.black,
                                            fontSize: 15.0),
                                        softWrap: true,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 130.0,
                                  ),
                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 130.0,
                                    margin: EdgeInsets.only(
                                        left: 10.0, top: 8.0, right: 10.0),
                                    child: Text(_projectListInfoDetailBean.desc,
                                        style: TextStyle(color: Colors.black54,
                                            fontSize: 12.0),
                                        softWrap: true,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 130.0,
                                    margin: EdgeInsets.only(
                                        left: 10.0, top: 8.0, right: 10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        Text(_projectListInfoDetailBean.author,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12.0)),
                                        Text(DateTimeUtils.parseMilliseconds(
                                            _projectListInfoDetailBean
                                                .publishTime).toString(),
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 10.0)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),
            ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

