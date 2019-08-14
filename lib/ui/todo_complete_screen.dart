import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/todo_list_model.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/ui/todo_add_screen.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// TODO 已完成列表页面
class TodoCompleteScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new TodoCompleteScreenState();
  }
}

class TodoCompleteScreenState extends BaseWidgetState<TodoCompleteScreen> {
  int _type = 0;
  int _page = 1;
  List<TodoBean> _todoBeanList = new List();

  /// listview 控制器
  ScrollController _scrollController = new ScrollController();

  /// 是否显示悬浮按钮
  bool _isShowFAB = false;

  /// 获取已完成TODO列表数据
  Future<Null> getDoneTodoList() async {
    _page = 1;
    ApiService().getDoneTodoList((TodoListModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          showContent();
          setState(() {
            _todoBeanList.clear();
            _todoBeanList.addAll(model.data.datas);
          });
        } else {
          showEmpty();
        }
      } else {
        Fluttertoast.showToast(msg: model.errorMsg);
      }
    }, (DioError error) {
      print(error.response);
      showError();
    }, _type, _page);
  }

  /// 获取更多已完成TODO列表数据
  Future<Null> getMoreDoneTodoList() async {
    _page = 1;
    ApiService().getDoneTodoList((TodoListModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          setState(() {
            _todoBeanList.addAll(model.data.datas);
          });
        } else {
          Fluttertoast.showToast(msg: "没有更多数据了");
        }
      } else {
        Fluttertoast.showToast(msg: model.errorMsg);
      }
    }, (DioError error) {
      print(error.response);
      showError();
    }, _type, _page);
  }

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);

    showLoading();
    getDoneTodoList();

    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreDoneTodoList();
      }
      if (_scrollController.offset < 200 && _isShowFAB) {
        setState(() {
          _isShowFAB = false;
        });
      } else if (_scrollController.offset >= 200 && !_isShowFAB) {
        setState(() {
          _isShowFAB = true;
        });
      }
    });
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
      body: RefreshIndicator(
        displacement: 15,
        onRefresh: getDoneTodoList,
        child: ListView.separated(
            itemBuilder: itemView,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 0.5,
                color: Colors.black26,
              );
            },
            physics: new AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: _todoBeanList.length + 1),
      ),
      // floatingActionButton: fabWidget()
    );
  }

  Widget itemView(BuildContext context, int index) {
    if (index < _todoBeanList.length) {
      TodoBean item = _todoBeanList[index];

      return InkWell(
        onTap: () {
          RouteUtil.push(context, TodoAddScreen(2, bean: item));
        },
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    item.title,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    item.content,
                    style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            )),
      );
    }
    return null;
  }

  /// 悬浮按钮
  @override
  Widget fabWidget() {
    return _isShowFAB
        ? null
        : FloatingActionButton(
            heroTag: "todo_done_list",
            child: Icon(Icons.edit),
            backgroundColor: ThemeUtils.currentColorTheme,
            onPressed: () {
              RouteUtil.push(context, TodoAddScreen(0));
            },
          );
  }

  @override
  void onClickErrorWidget() {
    showLoading();
    getDoneTodoList();
  }
}
