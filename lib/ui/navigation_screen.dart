import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/navigation_model.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/utils/common_util.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
import 'package:flutter_wanandroid/utils/toast_util.dart';
import 'package:flutter_wanandroid/widgets/refresh_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 导航页面
class NavigationScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new NavigationScreenState();
  }
}

class NavigationScreenState extends BaseWidgetState<NavigationScreen> {
  List<NavigationBean> _navigationList = new List();

  /// listview 控制器
  ScrollController _scrollController = new ScrollController();

  /// 是否显示悬浮按钮
  bool _isShowFAB = false;

  RefreshController _refreshController =
      new RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    showLoading().then((value) {
      getNavigationList();
    });

    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
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

  Future getNavigationList() async {
    apiService.getNavigationList((NavigationModel navigationModel) {
      if (navigationModel.errorCode == Constants.STATUS_SUCCESS) {
        if (navigationModel.data.length > 0) {
          showContent().then((value) {
            _refreshController.refreshCompleted();
            setState(() {
              _navigationList.clear();
              _navigationList.addAll(navigationModel.data);
            });
          });
        } else {
          showEmpty();
        }
      } else {
        showError();
        T.show(msg: navigationModel.errorMsg);
      }
    }, (DioError error) {
      showError();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  AppBar attachAppBar() {
    return AppBar(title: Text(""));
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: MaterialClassicHeader(),
        footer: RefreshFooter(),
        controller: _refreshController,
        onRefresh: getNavigationList,
        child: ListView.builder(
          itemBuilder: itemView,
          physics: new AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _navigationList.length,
        ),
      ),
      floatingActionButton: !_isShowFAB
          ? null
          : FloatingActionButton(
              heroTag: "navigation",
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                /// 回到顶部时要执行的动画
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 2000), curve: Curves.ease);
              },
            ),
    );
  }

  @override
  void onClickErrorWidget() {
    showLoading().then((value) {
      getNavigationList();
    });
  }

  Widget itemView(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              _navigationList[index].name,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: itemChildView(_navigationList[index].articles),
          ),
          Divider(height: 1),
        ],
      ),
    );
  }

  Widget itemChildView(List<NavigationArticleBean> children) {
    List<Widget> tiles = [];
    Widget content;
    for (var item in children) {
      tiles.add(
        new InkWell(
          onTap: () {
            RouteUtil.toWebView(context, item.title, item.link);
          },
          child: Chip(
            label: Text(
              item.title,
              style: TextStyle(
                  fontSize: 12.0,
                  color: CommonUtil.randomColor(),
                  fontStyle: FontStyle.italic),
            ),
            labelPadding: EdgeInsets.only(left: 3.0, right: 3.0),
            // backgroundColor: Color(0xfff1f1f1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
        ),
      );
    }

    content = Wrap(spacing: 2, alignment: WrapAlignment.start, children: tiles);

    return content;
  }
}
