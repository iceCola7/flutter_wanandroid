import 'package:flutter/material.dart';

/// 新增或编辑TODO
class TodoAddScreen extends StatefulWidget {
  /// 类型：0:新增  1:编辑  2:查看
  final int type;

  TodoAddScreen(this.type);

  @override
  State<StatefulWidget> createState() {
    return TodoAddScreenSate();
  }
}

class TodoAddScreenSate extends State<TodoAddScreen> {
  String title = "";

  @override
  void initState() {
    super.initState();

    title = widget.type == 0 ? "新增" : (widget.type == 1 ? "编辑" : "查看");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(title),
      ),
      body: Center(
        child: Text(title),
      ),
    );
  }
}
