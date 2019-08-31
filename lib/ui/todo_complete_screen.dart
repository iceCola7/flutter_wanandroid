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
import 'package:flutter_wanandroid/utils/toast_util.dart';
import 'package:flutter_wanandroid/widgets/item_todo_list.dart';
import 'package:flutter_wanandroid/widgets/loading_dialog.dart';
import 'package:flutter_wanandroid/widgets/refresh_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// TODO 已完成列表页面
class TodoCompleteScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new TodoCompleteScreenState();
  }
}

class TodoCompleteScreenState extends BaseWidgetState<TodoCompleteScreen> {
  /// 待办类型：0:只用这一个  1:工作  2:学习  3:生活
  int todoType = 0;
  int _page = 1;
  List<TodoBean> _todoBeanList = new List();

  /// listview 控制器
  ScrollController _scrollController = new ScrollController();

  /// 是否显示悬浮按钮
  bool _isShowFAB = false;

  final SlidableController slidableController = SlidableController();

  /// 重新构建的数据集合
  Map<String, List<TodoBean>> map = Map();

  RefreshController _refreshController =
      new RefreshController(initialRefresh: false);

  /// 获取已完成TODO列表数据
  Future getDoneTodoList() async {
    _page = 1;
    apiService.getDoneTodoList((TodoListModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          showContent();
          _refreshController.refreshCompleted(resetFooterState: true);
          setState(() {
            _todoBeanList.clear();
            _todoBeanList.addAll(model.data.datas);
          });
          rebuildData();
        } else {
          showEmpty();
        }
      } else {
        showError();
        T.show(msg: model.errorMsg);
      }
    }, (error) {
      showError();
    }, todoType, _page);
  }

  /// 获取更多已完成TODO列表数据
  Future getMoreDoneTodoList() async {
    _page++;
    apiService.getDoneTodoList((TodoListModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          _refreshController.loadComplete();
          setState(() {
            _todoBeanList.addAll(model.data.datas);
          });
          rebuildData();
        } else {
          _refreshController.loadNoData();
        }
      } else {
        _refreshController.loadFailed();
        T.show(msg: model.errorMsg);
      }
    }, (error) {
      _refreshController.loadFailed();
    }, todoType, _page);
  }

  /// 注册刷新TODO事件
  void registerRefreshEvent() {
    Application.eventBus.on<RefreshTodoEvent>().listen((event) {
      todoType = event.todoType;
      _todoBeanList.clear();
      showLoading();
      getDoneTodoList();
    });
  }

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);

    this.registerRefreshEvent();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    showLoading().then((value) {
      getDoneTodoList();
    });

    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // getMoreDoneTodoList();
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
    return AppBar(title: Text(""));
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
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: RefreshFooter(),
        controller: _refreshController,
        onRefresh: getDoneTodoList,
        onLoading: getMoreDoneTodoList,
        child: ListView.builder(
          itemBuilder: itemView,
          physics: new AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _todoBeanList.length,
        ),
      ),
      // floatingActionButton: fabWidget()
    );
  }

  Widget itemView(BuildContext context, int index) {
    TodoBean item = _todoBeanList[index];
    bool isShowSuspension = false;
    if (map.containsKey(item.dateStr)) {
      if (map[item.dateStr].length > 0) {
        if (map[item.dateStr][0].id == item.id) {
          isShowSuspension = true;
        }
      }
    }

    return ItemTodoList(
      isTodo: false,
      item: item,
      slidableController: slidableController,
      isShowSuspension: isShowSuspension,
      todoType: todoType,
      updateTodoCallback: (_id) {
        this.updateTodoState(_id, index);
      },
      deleteItemCallback: (_id) {
        this.deleteTodoById(_id, index);
      },
    );
  }

  /// 悬浮按钮
  @override
  Widget fabWidget() {
    return _isShowFAB
        ? null
        : FloatingActionButton(
            heroTag: "todo_done_list",
            child: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              RouteUtil.push(
                  context,
                  TodoAddScreen(
                    todoType: this.todoType,
                    editKey: 0,
                  ));
            },
          );
  }

  @override
  void onClickErrorWidget() {
    showLoading();
    getDoneTodoList();
  }

  /// 根据ID删除TODO
  Future deleteTodoById(int _id, int index) async {
    _showLoading(context);
    apiService.deleteTodoById((BaseModel model) {
      _dismissLoading(context);
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        T.show(msg: "删除成功");
        setState(() {
          _todoBeanList.removeAt(index);
        });
        rebuildData();
      } else {
        T.show(msg: model.errorMsg);
      }
    }, (error) {
      _dismissLoading(context);
    }, _id);
  }

  /// 仅更新完成状态Todo
  Future updateTodoState(int _id, int index) async {
    // status: 0或1，传1代表未完成到已完成，反之则反之。
    var params = {'status': 0};
    _showLoading(context);
    apiService.updateTodoState((BaseModel model) {
      _dismissLoading(context);
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        T.show(msg: "更新成功");
        setState(() {
          _todoBeanList.removeAt(index);
        });
        rebuildData();
      } else {
        T.show(msg: model.errorMsg);
      }
    }, (error) {
      _dismissLoading(context);
    }, _id, params);
  }
}
