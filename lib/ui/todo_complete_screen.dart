import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';

/// TODO 已完成列表页面
class TodoCompleteScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new TodoCompleteScreenState();
  }
}

class TodoCompleteScreenState extends BaseWidgetState<TodoCompleteScreen> {
  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
  }

  @override
  AppBar attachAppBar() {
    return AppBar(
      title: Text(""),
    );
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("complete"),
      ),
    );
  }

  @override
  void onClickErrorWidget() {}
}
