import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/ui/drawer_screen.dart';
import 'package:flutter_wanandroid/ui/home_screen.dart';
import 'package:flutter_wanandroid/ui/hot_word_screen.dart';
import 'package:flutter_wanandroid/ui/knowledge_tree_screen.dart';
import 'package:flutter_wanandroid/ui/navigation_screen.dart';
import 'package:flutter_wanandroid/ui/project_screen.dart';
import 'package:flutter_wanandroid/ui/wechat_screen.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';

class Main extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainState();
  }
}

class MainState extends State<Main> {
  int _selectedIndex = 0; // 当前选中的索引

  final bottomBarTitles = ["首页", "知识体系", "公众号", "导航", "项目"];

  var pages = <Widget>[
    HomeScreen(),
    KnowledgeTreeScreen(),
    WeChatScreen(),
    NavigationScreen(),
    ProjectScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: DrawerScreen(),
        appBar: AppBar(
          title: new Text(bottomBarTitles[_selectedIndex]),
          bottom: null,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                RouteUtil.push(context, HotWordScreen());
              },
            )
          ],
        ),
        body: new IndexedStack(
          children: pages,
          index: _selectedIndex,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text(bottomBarTitles[0])),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment), title: Text(bottomBarTitles[1])),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), title: Text(bottomBarTitles[2])),
            BottomNavigationBarItem(
                icon: Icon(Icons.navigation), title: Text(bottomBarTitles[3])),
            BottomNavigationBarItem(
                icon: Icon(Icons.book), title: Text(bottomBarTitles[4])),
          ],
          type: BottomNavigationBarType.fixed, // 设置显示模式
          currentIndex: _selectedIndex, // 当前选中项的索引
          onTap: _onItemTapped, // 选择的处理事件
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('提示'),
            content: new Text('确定退出应用吗？'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('再看一会', style: TextStyle(color: Colors.cyan)),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('退出', style: TextStyle(color: Colors.cyan)),
              ),
            ],
          ),
        ) ??
        false;
  }
}
