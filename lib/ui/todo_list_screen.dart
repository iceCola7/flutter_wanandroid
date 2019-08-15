import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/data/model/todo_list_model.dart';
import 'package:flutter_wanandroid/event/refresh_todo_event.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/ui/todo_add_screen.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';
import 'package:flutter_wanandroid/widgets/loading_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sticky_headers/sticky_headers.dart';

/// TODO 待办列表页面
class TodoListScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new TodoListScreenState();
  }
}

class TodoListScreenState extends BaseWidgetState<TodoListScreen> {
  int _type = 0;
  int _page = 1;
  List<TodoBean> _todoBeanList = new List();

  /// listview 控制器
  ScrollController _scrollController = new ScrollController();

  /// 是否显示悬浮按钮
  bool _isShowFAB = false;

  final SlidableController slidableController = SlidableController();

  /// 重新构建的数据集合
  Map<String, List<TodoBean>> map = Map();

  /// 获取待办TODO列表数据
  Future<Null> getNoTodoList() async {
    _page = 1;
    ApiService().getNoTodoList((TodoListModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          showContent();
          setState(() {
            _todoBeanList.clear();
            _todoBeanList.addAll(model.data.datas);
          });
          rebuildData();
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

  /// 获取更多待办TODO列表数据
  Future<Null> getMoreNoTodoList() async {
    _page++;
    ApiService().getNoTodoList((TodoListModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          setState(() {
            _todoBeanList.addAll(model.data.datas);
          });
          rebuildData();
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

  /// 注册刷新TODO事件
  void registerRefreshEvent() {
    Application.eventBus.on<RefreshTodoEvent>().listen((event) {
      showLoading();
      getNoTodoList();
    });
  }

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);

    this.registerRefreshEvent();

    showLoading();
    getNoTodoList();

    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreNoTodoList();
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

  /// 显示Loading
  _showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return new LoadingDialog(
            outsideDismiss: false,
            loadingText: "loading...",
          );
        });
  }

  /// 隐藏Loading
  _dismissLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// 重新构建数据
  void rebuildData() {
    map.clear();
    Set<String> set = new Set();
    _todoBeanList.forEach((bean) {
      set.add(bean.dateStr);
    });

    set.forEach((s) {
      List<TodoBean> list = new List();
      map.putIfAbsent(s, () => list);
    });

    _todoBeanList.forEach((bean) {
      map[bean.dateStr].add(bean);
    });
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        displacement: 15,
        onRefresh: getNoTodoList,
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
      // floatingActionButton: fabWidget(),
    );
  }

  Widget itemView(BuildContext context, int index) {
    if (index < _todoBeanList.length) {
      TodoBean item = _todoBeanList[index];

      bool isShowSuspension = false;
      if (map.containsKey(item.dateStr)) {
        if (map[item.dateStr].length > 0) {
          if (map[item.dateStr][0].id == item.id) {
            isShowSuspension = true;
          }
        }
      }

      return StickyHeader(
          header: Offstage(
            offstage: !isShowSuspension,
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              alignment: Alignment.centerLeft,
              height: 28,
              color: Color(0xFFF5F5F5),
              child: Text(
                item.dateStr,
                style: TextStyle(fontSize: 12, color: Color(0xFF00BCD4)),
              ),
            ),
          ),
          content: Slidable(
            controller: slidableController,
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: InkWell(
              onTap: () {
                RouteUtil.push(context, TodoAddScreen(1, bean: item));
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
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF757575)),
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  )),
            ),
            secondaryActions: <Widget>[
              InkWell(
                onTap: () {
                  this.updateTodoState(item.id, index);
                },
                child: Container(
                  alignment: Alignment.center,
                  color: const Color(0xFF4CAF50),
                  child: Text(
                    "已完成",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  this.deleteTodoById(item.id, index);
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.red,
                  child: Text(
                    "删除",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ));
    }
    return null;
  }

  @override
  Widget fabWidget() {
    return _isShowFAB
        ? null
        : FloatingActionButton(
            heroTag: "todo_list",
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
    getNoTodoList();
  }

  /// 根据ID删除TODO
  Future<Null> deleteTodoById(int _id, int index) async {
    _showLoading(context);
    ApiService().deleteTodoById((BaseModel model) {
      _dismissLoading(context);
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        Fluttertoast.showToast(msg: "删除成功");
        setState(() {
          _todoBeanList.removeAt(index);
        });
        rebuildData();
      } else {
        Fluttertoast.showToast(msg: model.errorMsg);
      }
    }, (DioError error) {
      _dismissLoading(context);
      print(error.response);
    }, _id);
  }

  /// 仅更新完成状态Todo
  Future<Null> updateTodoState(int _id, int index) async {
    // status: 0或1，传1代表未完成到已完成，反之则反之。
    var params = {'status': 1};
    _showLoading(context);
    ApiService().updateTodoState((BaseModel model) {
      _dismissLoading(context);
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        Fluttertoast.showToast(msg: "更新成功");
        setState(() {
          _todoBeanList.removeAt(index);
        });
        rebuildData();
      } else {
        Fluttertoast.showToast(msg: model.errorMsg);
      }
    }, (DioError error) {
      _dismissLoading(context);
      print(error.response);
    }, _id, params);
  }
}
