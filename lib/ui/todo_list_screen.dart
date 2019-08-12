import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/todo_list_model.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';

/// TODO 待办列表页面
class TodoListScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new TodoListScreenState();
  }
}

class TodoListScreenState extends BaseWidgetState<TodoListScreen> {
  int _page = 1;

  /// 获取TODO列表数据
  Future<Null> getTodoList() async {
    ApiService().getTodoList((TodoListModel model) {
      print(model);
      if (model.errorCode == Constants.STATUS_SUCCESS) {
      } else {}
    }, (DioError error) {
      print(error.response);
      showError();
    }, _page);
  }

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
    getTodoList();
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
        child: Text("todo"),
      ),
    );
  }

  @override
  void onClickErrorWidget() {}
}
