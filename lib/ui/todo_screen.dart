import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';

class TodoScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return TodoScreenState();
  }
}

class TodoScreenState extends BaseWidgetState<TodoScreen> {
  @override
  AppBar attachAppBar() {
    return new AppBar(
      title: Text(""),
    );
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    return Text("");
  }

  @override
  void onClickErrorWidget() {}
}
