import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/project_article_model.dart';
import 'package:flutter_wanandroid/data/model/project_tree_model.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/utils/toast_util.dart';
import 'package:flutter_wanandroid/widgets/item_project_list.dart';
import 'package:flutter_wanandroid/widgets/refresh_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 项目页面
class ProjectScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new ProjectScreenState();
  }
}

class ProjectScreenState extends BaseWidgetState<ProjectScreen>
    with TickerProviderStateMixin {
  List<ProjectTreeBean> _projectTreeList = new List();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    showLoading().then((value) {
      getProjectTreeList();
    });
  }

  Future getProjectTreeList() async {
    apiService.getProjectTreeList((ProjectTreeModel projectTreeModel) {
      if (projectTreeModel.errorCode == Constants.STATUS_SUCCESS) {
        if (projectTreeModel.data.length > 0) {
          showContent();
          setState(() {
            _projectTreeList.clear();
            _projectTreeList.addAll(projectTreeModel.data);
          });
        } else {
          showEmpty();
        }
      } else {
        showError();
        T.show(msg: projectTreeModel.errorMsg);
      }
    }, (DioError error) {
      showError();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  AppBar attachAppBar() {
    return AppBar(title: Text(""));
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    _tabController =
        new TabController(length: _projectTreeList.length, vsync: this);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            height: 50,
            child: TabBar(
                indicatorColor: Colors.white,
                labelStyle: TextStyle(fontSize: 16),
                unselectedLabelStyle: TextStyle(fontSize: 16),
                controller: _tabController,
                isScrollable: true,
                tabs: _projectTreeList.map((item) {
                  return Tab(text: item.name);
                }).toList()),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: _projectTreeList.map((item) {
                  return ProjectArticleScreen(item.id);
                }).toList()),
          )
        ],
      ),
    );
  }

  @override
  void onClickErrorWidget() {
    showLoading().then((value) {
      getProjectTreeList();
    });
  }
}

class ProjectArticleScreen extends StatefulWidget {
  final int id;

  ProjectArticleScreen(this.id);

  @override
  State<StatefulWidget> createState() {
    return new ProjectArticleScreenState();
  }
}

class ProjectArticleScreenState extends State<ProjectArticleScreen>
    with AutomaticKeepAliveClientMixin {
  List<ProjectArticleBean> _projectArticleList = new List();

  /// listview 控制器
  ScrollController _scrollController = new ScrollController();

  /// 是否显示悬浮按钮
  bool _isShowFAB = false;
  int _page = 1;

  RefreshController _refreshController =
      new RefreshController(initialRefresh: true);

  Future<Null> getProjectArticleList() async {
    _page = 1;
    int _id = widget.id;
    apiService.getProjectArticleList((ProjectArticleListModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        _refreshController.refreshCompleted(resetFooterState: true);
        setState(() {
          _projectArticleList.clear();
          _projectArticleList.addAll(model.data.datas);
        });
      } else {
        T.show(msg: model.errorMsg);
      }
    }, (DioError error) {}, _id, _page);
  }

  Future<Null> getMoreProjectArticleList() async {
    _page++;
    int _id = widget.id;

    apiService.getProjectArticleList((ProjectArticleListModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          _refreshController.loadComplete();
          setState(() {
            _projectArticleList.addAll(model.data.datas);
          });
        } else {
          _refreshController.loadNoData();
        }
      } else {
        _refreshController.loadFailed();
      }
    }, (DioError error) {
      _refreshController.loadFailed();
    }, _id, _page);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getProjectArticleList();

    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // getMoreProjectArticleList();
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
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: RefreshFooter(),
        controller: _refreshController,
        onRefresh: getProjectArticleList,
        onLoading: getMoreProjectArticleList,
        child: ListView.builder(
          itemBuilder: itemView,
          physics: new AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _projectArticleList.length,
        ),
      ),
      floatingActionButton: !_isShowFAB
          ? null
          : FloatingActionButton(
              heroTag: "project",
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                /// 回到顶部时要执行的动画
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 2000), curve: Curves.ease);
              },
            ),
    );
  }

  Widget itemView(BuildContext context, int index) {
    ProjectArticleBean item = _projectArticleList[index];
    return ItemProjectList(item: item);
  }
}
