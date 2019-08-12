import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/ui/todo_complete_screen.dart';
import 'package:flutter_wanandroid/ui/todo_list_screen.dart';

/// TODO 页面
class TodoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TodoScreenState();
  }
}

class TodoScreenState extends State<TodoScreen> {
  int _selectedIndex = 0; // 当前选中的索引

  final bottomBarTitles = ["待办", "已完成"];

  var pages = <Widget>[
    TodoListScreen(),
    TodoCompleteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(bottomBarTitles[_selectedIndex]),
        bottom: null,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: new IndexedStack(
        children: pages,
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.description), title: Text(bottomBarTitles[0])),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle), title: Text(bottomBarTitles[1])),
        ],
        type: BottomNavigationBarType.fixed, // 设置显示模式
        currentIndex: _selectedIndex, // 当前选中项的索引
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        }, //
      ),
    );
  }
}
