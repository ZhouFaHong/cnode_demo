import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'DateSwitch.dart';

class UserPage extends StatefulWidget {
  final arguments;
  UserPage({Key key, this.arguments}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState(this.arguments);
}

class _UserPageState extends State<UserPage> {
  final arguments;
  _UserPageState(this.arguments);

  var _data = {};
  List _listRecent = [];
  List _listReply = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getData();
  }

  _getData() async {
    var url = 'https://cnodejs.org/api/v1/user/${this.arguments['userId']}';
    var response = await Dio().get(url);
    if (response.statusCode == 200) {
      setState(() {
        this._data = response.data['data'];
        this._listRecent = this._data['recent_topics'];
        this._listReply = this._data['recent_replies'];
        print('返回的数据：${this._data}');
      });
    } else {
      print("Request failed with status: ${response.statusCode}.");
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('用户信息'),
        ),
        body: this._data.length==0?Text('数据加载中'):
        ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 用户信息
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        child: ClipRRect(
                          // 图片切圆角
                          child: Image.network(this._data['avatar_url'] == null
                              ? ''
                              : this._data['avatar_url']),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                    Text(
                      this._data['loginname'] == null
                          ? ''
                          : this._data['loginname'],
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Color.fromRGBO(119, 128, 135, 1)),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    '${this._data['score'] == null ? '' : this._data['score']}  积分',
                    style: TextStyle(
                        fontSize: 18.0, color: Color.fromRGBO(51, 51, 51, 1)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    '注册时间  ${switchToDateTime(this._data['create_at'])}',
                    style: TextStyle(
                        fontSize: 18.0, color: Color.fromRGBO(171, 171, 171, 1)),
                  ),
                ),
              ],
            ),
            Container(
              height: 40.0,
              alignment: Alignment.centerLeft,
              color: Color.fromRGBO(246, 246, 246, 1),
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  '最近创建的话题',
                  style: TextStyle(
                      fontSize: 18.0, color: Color.fromRGBO(68, 68, 68, 1)),
                ),
              ),
            ),
            Column(
              children: this._listRecent.length==0 ?
              [Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15,top: 15),
                  child: Text('无话题',style:TextStyle(
                color:Color.fromRGBO(51, 51, 51, 1),
                fontSize:18.0,
              )),
                ),
              )]:
              this._listRecent.map((value) {
                return HomeCell(value);
              }).toList(),
            ),
            Container(
              height: 40.0,
              alignment: Alignment.centerLeft,
              color: Color.fromRGBO(246, 246, 246, 1),
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  '最近参与的话题',
                  style: TextStyle(
                      fontSize: 18.0, color: Color.fromRGBO(68, 68, 68, 1)),
                ),
              ),
            ),
            Column(
              children: this._listReply.length==0 ?
              [Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15,top: 15),
                  child: Text('无话题',style:TextStyle(
                color:Color.fromRGBO(51, 51, 51, 1),
                fontSize:18.0,
              )),
                ),
              )]:
              this._listReply.map((value) {
                return HomeCell(value);
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
  HomeCell(this.value);
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
      visible = false;
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
                            Navigator.of(context).pushReplacementNamed('/userPage',
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
                                fontSize: 16.0,
                                color: Color.fromRGBO(0, 136, 204, 1)),
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
              print('点击了cell:${value['title']}');
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


