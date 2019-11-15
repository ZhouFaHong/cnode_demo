import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'DateSwitch.dart';
// import 'package:cnode_demo/httpRequest/HttpRequest.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  List _list = ['全部', '精华', '分享', '客户端测试'];
  List _listType = ['all', 'good', 'share', 'dev'];
  List _dataSources = [];

  List _listAll = [];
  List _listDood = [];
  List _listShare = [];
  List _listDev = [];

  //重写keepAlive 为ture ，就是可以有记忆功能了。
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // 生命周期函数

    this._tabController = new TabController(vsync: this, length: 4);

    this._tabController.addListener(() {
      // 点击

      setState(() {
        this._requestData({
          'page': 1,
          'limit': 20,
          'tab': this._listType[this._tabController.index]
        });
        print(this._tabController.index);
      });
    });

    this._requestData({
      'page': 1,
      'limit': 20,
      'tab': this._listType[this._tabController.index]
    }); // 页面加载的时候网络请求

    super.initState();
  }

  //网络请求数据
  _requestData(paramas) async {
    print('paramas=${paramas}');
    //服务器地址
    var serverUrl =
        'https://cnodejs.org/api/v1/topics?page=${paramas['page']}&limit=${paramas['limit']}&tab=${paramas['tab']}';

    print('serverUrl=${serverUrl}');
    //处理网络请求下来的数据
    var response = await Dio().get(serverUrl);
    if (response.statusCode == 200) {
      setState(() {
        switch (this._tabController.index) {
          case 0:
            {
              this._listAll = response.data['data'];
            }
            break;
          case 1:
            {
              this._listDood = response.data['data'];
            }
            break;
          case 2:
            {
              this._listShare = response.data['data'];
            }
            break;
          case 3:
            {
              this._listDev = response.data['data'];
            }
            break;
          default:
        }

        this._dataSources = response.data['data'];
        print(
            "${this._list[this._tabController.index]},${this._dataSources.length}");
      });
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
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
          backgroundColor: Colors.white,
          brightness: Brightness.light, // 修改状态栏的颜色
          //  title: Text('TabBarControllerPage'),
          title: TabBar(
            isScrollable: true, // 设置是否可以滚动
            controller: this._tabController, // 注意
            /// 通过数组来动态添加头部的tab
            tabs: this._list.map((title) => Tab(text: title)).toList(),

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
            indicatorColor: Color.fromRGBO(128, 189, 1, 1), // 指示器的颜色
          ),
        ),
        body: TabBarView(
          controller: this._tabController, // 注意
          children: <Widget>[
            ListView(
              children: this._listAll.map((value) {
                
                return HomeCell(
                    value, this._listType[this._tabController.index]);
              }).toList(),
            ),
            ListView(
              children: this._listDood.map((value) {
                return HomeCell(
                    value, this._listType[this._tabController.index]);
              }).toList(),
            ),
            ListView(
              children: this._listShare.map((value) {
                return HomeCell(
                    value, this._listType[this._tabController.index]);
              }).toList(),
            ),
            ListView(
              children: this._listDev.map((value) {
                return HomeCell(
                    value, this._listType[this._tabController.index]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// 自定义cell组件
class HomeCell extends StatelessWidget {
  final value;
  final tab;
  HomeCell(this.value, this.tab);
  @override
  Widget build(BuildContext context) {
    String text = '';
    Color bgColor = Color.fromRGBO(229, 229, 229, 1);
    Color textColor = Color.fromRGBO(153, 153, 153, 1);
    bool visible = true;

    if (value['top'] == true) {
      bgColor = Color.fromRGBO(128, 189, 1, 1);
      textColor = Colors.white;
      text = '置顶';
      visible = true;
    } else if (value['good'] == true) {
      bgColor = Color.fromRGBO(128, 189, 1, 1);
      textColor = Colors.white;
      text = '精华';
      visible = true;
    } else {
      if (tab == 'all') {
        visible = true;
        if (value['tab'] == 'ask') {
          text = '问答';
        } else if (value['tab'] == 'share') {
          text = '分享';
        } else {
          text = '招聘';
        }
      } else if (tab == 'share' && value['top'] == true) {
        bgColor = Color.fromRGBO(128, 189, 1, 1);
        textColor = Colors.white;
        text = '置顶';
        visible = true;
      } else if (tab == 'dev' && value['top'] == true) {
        bgColor = Color.fromRGBO(128, 189, 1, 1);
        textColor = Colors.white;
        text = '置顶';
        visible = true;
      } else {
        visible = false;
      }
    }
    
    return Container(
      margin: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Stack(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        child: GestureDetector(
                          child: ClipRRect(
                            // 图片切圆角
                            child: Image.network(value['author']['avatar_url']),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/userPage',arguments: {
                              'userId':value['author']['loginname']
                            });
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: visible,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                        child: Container(
                          width: 40,
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: bgColor),
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.0, color: textColor),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 220,
                          child: Text(
                            value['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.black87),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${value['reply_count']}',
                              style: TextStyle(
                                  color: Color.fromRGBO(158, 120, 192, 1)),
                            ),
                            Text('/'),
                            Text(
                              '${value['visit_count']}',
                              style: TextStyle(
                                  color: Color.fromRGBO(180, 180, 180, 1)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                new Positioned(
                  bottom: 10,
                  right: 10,
                  child: Text(
                    switchToDateTime(value['last_reply_at']),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Color.fromRGBO(119, 128, 135, 1)),
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/topicDetailPage',arguments: value);
            },
          ),
          Divider(
            height: 1.0,
          ),
        ],
      ),
    );
  }
}