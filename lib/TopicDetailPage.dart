import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'DateSwitch.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class TopicDetailPage extends StatefulWidget {
  final arguments;
  TopicDetailPage({Key key, this.arguments}) : super(key: key);

  @override
  _TopicDetailPageState createState() => _TopicDetailPageState(this.arguments);
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  final arguments;
  _TopicDetailPageState(this.arguments);

  var _data = {};
  List _listReplies = [];

  @override
  void initState() {
    this._getData();
    super.initState();
  }

  _getData() async {
    // https://cnodejs.org/api/v1/topic/5433d5e4e737cbe96dcef312
    var url = 'https://cnodejs.org/api/v1/topic/${this.arguments['id']}';
    var response = await Dio().get(url);
    if (response.statusCode == 200) {
      setState(() {
        this._data = response.data['data'];
        this._listReplies = this._data['replies'];

        print('返回的数据：${this._data}');
      });
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  @override
  Widget build(BuildContext context) {
    String text = '置顶';
    String tab = '';
    Color bgColor = Color.fromRGBO(128, 189, 1, 1);
    Color textColor = Colors.white;
    bool visible = false;
    if (this.arguments['top'] == true) {
      visible = true;
      text = '置顶';
    } else if (this.arguments['good'] == true) {
      visible = true;
      text = '精华';
    }

    if (this.arguments['tab'] == 'share') {
      tab = '分享';
    } else if (this.arguments['tab'] == 'ask') {
      tab = '问答';
    } else if (this.arguments['tab'] == 'dev') {
      tab = '客户端测试';
    }
    print('id = ${this.arguments['id']}');

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('文章详情'),
        ),
        body: this._data.length == 0
            ? Text('正在加载中')
            : Container(
                child: ListView(
                  children: <Widget>[
                    visible == true
                        ? ListTile(
                            leading: Visibility(
                              visible: visible,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Container(
                                  width: 40,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: bgColor),
                                  child: Text(
                                    text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14.0, color: textColor),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              '${this._data['title']}',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              maxLines: 20,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              '${this._data['title']}',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              maxLines: 20,
                            ),
                          ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                                '• 发布于 ${switchToDateTime(this._data['last_reply_at'])}'),
                            Text('• 作者 ${this._data['author']['loginname']}'),
                            Text('• ${this._data['visit_count']} 次浏览'),
                            Text('• 来自 $tab'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            child: Html(data: this._data['content']),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 40.0,
                      alignment: Alignment.centerLeft,
                      color: Color.fromRGBO(246, 246, 246, 1),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          '${this._data['reply_count']} 回复',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Color.fromRGBO(68, 68, 68, 1)),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: this._listReplies.map((value) {
                        bool v = value['author']['loginname']==this._data['author']['loginname']?true:false;
                        return MyCell(
                            value, this._listReplies.indexOf(value) + 1,v);
                      }).toList(),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class MyCell extends StatelessWidget {
  final _value;
  final _index;
  final _visible;

  const MyCell(this._value, this._index,this._visible);

  @override
  Widget build(BuildContext context) {
    bool praise = true;
    if (this._value['ups'].length == 0) {
      praise = false;
    }
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 40.0,
                        height: 40.0,
                        child: GestureDetector(
                          child: ClipRRect(
                            // 图片切圆角
                            child: Image.network(
                                this._value['author']['avatar_url']),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/userPage',
                                arguments: {
                                  'userId': this._value['author']['loginname']
                                });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        this._value['author']['loginname'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Color.fromRGBO(102, 102, 102, 1),
                            // fontWeight: FontWeight.w500
                            ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        '${this._index}楼•${switchToDateTime(this._value['create_at'])}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Color.fromRGBO(0, 136, 204, 1),
                          
                        ),
                      ),
                      SizedBox(width: 10,),
                      Visibility(
                      visible: this._visible,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                        child: Container(
                          width: 40,
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Color.fromRGBO(107, 164, 78, 1)),
                          child: Text(
                            '作者',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.0, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Visibility(
                      visible: praise,
                      child: Text(
                        '点赞 ${this._value['ups'].length}',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Color.fromRGBO(102, 102, 102, 1),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Html(data: this._value['content']),
          ),
          Divider(
            height: 1,
          )
        ],
      ),
    );
  }
}
