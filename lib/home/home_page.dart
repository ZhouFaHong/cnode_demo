import 'package:flutter/material.dart';
import 'head_tab.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List _list = ['全部', '精华', '分享', '问答', '招聘','客户端测试'];
  List _listType = ['all', 'good', 'share','ask','job', 'dev'];

  @override
  void initState() {
    // 生命周期函数

    this._tabController = new TabController(vsync: this, length: _list.length);

    this._tabController.index = 0;
    this._tabController.addListener(() {
      // 点击
    });
  }

  // 生命周期函数
  @override
  void dispose() {
    // 当组件销毁的时候调用
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(

          // elevation: 0, //去掉Appbar底部阴影
          backgroundColor: Colors.white,
          brightness: Brightness.light, // 修改状态栏的颜色
          //  title: Text('TabBarControllerPage'),
          title: TabBar(

            isScrollable: true, // 设置是否可以滚动

            controller: this._tabController, // 注意

            labelColor: Colors.white, // 选中字体的颜色
            unselectedLabelColor: Color.fromRGBO(128, 189, 1, 1), // 未选中字体的颜色
            labelStyle: TextStyle(
              // 选中Label背景的颜色
              backgroundColor: Color.fromRGBO(128, 189, 1, 1),
              color: Colors.white,
            ),
            unselectedLabelStyle: TextStyle(
                // 未选中Label背景的颜色
                backgroundColor: Colors.white,
                color: Color.fromRGBO(128, 189, 1, 1)),
            indicatorColor: Colors.white, // 指示器的颜色
            // indicatorSize: TabBarIndicatorSize.tab,
            // indicator: new ShapeDecoration(
            //     color: Colors.green,
            //     shape: new Border.all(
            //       color: Colors.green,
            //       width: 1.0,
            //     ),
            //   ),

            /// 通过数组来动态添加头部的tab
            tabs: this._list.map((title) => Tab(text: title)).toList(),
          ),
        ),
        /// 对应的view
        body: TabBarView(
          controller: this._tabController, // 注意
          children: this._listType.map((value) {
            return HomeTabBar(value);
          }).toList(),
        ),
      ),
    );
  }
}
