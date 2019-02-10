import 'package:flutter/material.dart';
import 'package:flutter_wan_android/widget/zhu_ye_widget.dart';
import 'package:flutter_wan_android/widget/zhi_shi_ti_xi_widget.dart';
import 'package:flutter_wan_android/widget/xiang_mu_widget.dart';
import 'package:flutter_wan_android/widget/ge_ren_zhong_xin_widget.dart';
import 'package:flutter_wan_android/utils/system_chrome_utils.dart';
import 'package:flutter_wan_android/utils/toast_utils.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with AutomaticKeepAliveClientMixin {

  int _currentIndex = 0;
  int _exitTime = 0;

  List<Widget> _mainPartWidget;

  Widget _zhuYeWidget = ZhuYeWidget();
  Widget _zhiShiTiXiWidget = ZhiShiTiXiWidget();
  Widget _xiangMuWidget = XiangMuWidget();
  Widget _geRenZhongXinWidget = GeRenZhongXinWidget();

  @override
  void initState() {
    super.initState();
    SystemChromeUtils.showStatusBarAndBottomNavigationBar();
    _mainPartWidget = [_zhuYeWidget,_zhiShiTiXiWidget,_xiangMuWidget,_geRenZhongXinWidget];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body:IndexedStack(
            children:_mainPartWidget,
            index:_currentIndex,
          ),
          bottomNavigationBar:BottomNavigationBar(
            key:PageStorageKey(_currentIndex),
            type:BottomNavigationBarType.fixed,
            currentIndex:_currentIndex,
            onTap:(int index){
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon:Icon(
                    Icons.home,
                    color:_currentIndex == 0 ? Colors.green : Colors.black,
                  ),
                  title:Text(
                      '主页',
                      style:TextStyle(
                          color:_currentIndex == 0? Colors.green:Colors.black,
                          fontSize:15.0
                      )
                  )
              ),
              BottomNavigationBarItem(
                  icon:Icon(
                    Icons.widgets,
                    color:_currentIndex == 1? Colors.green:Colors.black,
                  ),
                  title:Text(
                    '知识体系',
                    style: TextStyle(
                      color:_currentIndex == 1? Colors.green:Colors.black,
                      fontSize:15.0,
                    ),
                  )
              ),
              BottomNavigationBarItem(
                  icon:Icon(
                    Icons.work,
                    color:_currentIndex == 2? Colors.green:Colors.black,
                  ),
                  title:Text(
                    '项目',
                    style: TextStyle(
                      color:_currentIndex == 2? Colors.green:Colors.black,
                      fontSize:15.0,
                    ),
                  )
              ),
              BottomNavigationBarItem(
                icon:Icon(
                  Icons.person,
                  color:_currentIndex == 3? Colors.green:Colors.black,
                ),
                title:Text(
                  '个人中心',
                  style: TextStyle(
                    color:_currentIndex == 3? Colors.green:Colors.black,
                    fontSize:15.0,
                  ),
                ),
              )
            ],
          ),
        ),
        onWillPop: (){
          if(DateTime.now().millisecondsSinceEpoch - _exitTime > 2000){
            _exitTime = DateTime.now().millisecondsSinceEpoch;
            ToastUtils.showShortToast("再次点击退出APP");
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
