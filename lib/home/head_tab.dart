import 'package:flutter/material.dart';
import 'package:cnode_demo/HomeList.dart';

class HomeTabBar extends StatefulWidget {

  var type;
  HomeTabBar(this.type,{Key key}) : super(key: key);

  @override
  _HomeTabBarState createState() => _HomeTabBarState(this.type);
}

class _HomeTabBarState extends State<HomeTabBar> with AutomaticKeepAliveClientMixin{

var type;
_HomeTabBarState(this.type);
  //重写keepAlive 为ture ，就是可以有记忆功能了。
  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         body: new HomeList(type: this.type,),
       ),
    );
  }
}