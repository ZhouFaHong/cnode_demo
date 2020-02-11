import 'package:flutter/material.dart';
import 'package:cnode_demo/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    print('------------------11111-------------');
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // 去除右上角Debug标签
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      // 通过配置文件进行路由
      onGenerateRoute: onGenerateRoute,
    );
  }
}
