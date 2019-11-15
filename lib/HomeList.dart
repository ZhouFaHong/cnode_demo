import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'DateSwitch.dart';

class HomeList extends StatefulWidget {
  String type;
  //构造器传递数据（并且接收上个页面传递的数据）
  HomeList({Key key, this.type}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomeListState(type: this.type);
  }
}

class HomeListState extends State<HomeList> {
  String type;
  String typeName;
  List dataList = new List();
  int currentPage = 0; //第一页
  int pageSize = 20; //页容量
  int totalSize = 100000000; //总条数
  String loadMoreText = "";
  TextStyle loadMoreTextStyle =
      new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
  TextStyle titleStyle =
      new TextStyle(color: const Color(0xFF757575), fontSize: 14.0);
  //初始化滚动监听器，加载更多使用
  ScrollController _controller = new ScrollController();

  /**
   * 构造器接收（MovieList）数据
   */
  HomeListState({Key key, this.type}) {
    //固定写法，初始化滚动监听器，加载更多使用
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel && dataList.length < totalSize) {
        setState(() {
          loadMoreText = "正在加载中...";
          loadMoreTextStyle =
              new TextStyle(color: const Color(0xFF4483f6), fontSize: 14.0);
        });
        loadMoreData();
      } else {
        // setState(() {
        //   loadMoreText = "正在加载中...";
        //   loadMoreTextStyle =
        //       new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
        // });
      }
    });
  }

  //加载列表数据
  loadMoreData() async {
    this.currentPage++;
    print('page: ${this.currentPage}');
    var url =
        'https://cnodejs.org/api/v1/topics?page=$currentPage&limit=$pageSize&tab=${this.type}';
    print(url);
    Dio dio = new Dio();
    Response response = await dio.get(url);
    setState(() {
      dataList.addAll(response.data["data"]);
      totalSize = 1000000000;
    });
  }

  @override
  void initState() {
    super.initState();
    //加载第一页数据
    loadMoreData();
  }

  /**
   * 下拉刷新,必须异步async不然会报错
   */
  Future _pullToRefresh() async {
    currentPage = 0;
    dataList.clear();
    loadMoreData();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: dataList.length == 0
          ? new Center(child: new CircularProgressIndicator())
          : new RefreshIndicator(
              color: const Color(0xFF4483f6),
              //下拉刷新
              child: ListView.builder(
                itemCount: dataList.length + 1,
                itemBuilder: (context, index) {
                  if (index == dataList.length) {
                    return _buildProgressMoreIndicator();
                  } else {
                    return HomeCell(index, context);
                  }
                },
                controller: _controller, //指明控制器加载更多使用
              ),
              onRefresh: _pullToRefresh,
            ),
    );
  }

  /**
   * 加载更多进度条
   */
  Widget _buildProgressMoreIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
        child: new Text(loadMoreText, style: loadMoreTextStyle),
      ),
    );
  }

  HomeCell(index, context) {
    var tab = this.type;
    var value = dataList[index];
    // print(value);
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
                            Navigator.pushNamed(context, '/userPage',
                                arguments: {
                                  'userId': value['author']['loginname']
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
              Navigator.pushNamed(context, '/topicDetailPage',
                  arguments: value);
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
