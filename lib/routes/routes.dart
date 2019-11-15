import 'package:flutter/material.dart';
import 'package:cnode_demo/UserPage.dart';
import 'package:cnode_demo/TopicDetailPage.dart';
import 'package:cnode_demo/home/home_page.dart';


// 配置路由
final routes = 
{
  '/':(context,{arguments}) => MyHomePage(),
  '/userPage':(context,{arguments}) => UserPage(arguments:arguments),
  '/topicDetailPage':(context,{arguments}) => TopicDetailPage(arguments:arguments),
  
};


// 固定写法 
var onGenerateRoute = (RouteSettings settiings){
        // 统一处理
        final String name = settiings.name;
        final Function pageContentBuilder = routes[name];
        if (pageContentBuilder != null) {
          if (settiings.arguments != null) {
            final Route route = MaterialPageRoute(
              builder: (context)=>pageContentBuilder(context,arguments:settiings.arguments));
            return route;
          }else{
            final Route route = MaterialPageRoute(
              builder: (context)=>pageContentBuilder(context));
              return route;
          }
          
        }
      };