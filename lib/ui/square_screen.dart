import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/article_model.dart';
import 'package:flutter_wanandroid/event/refresh_share_event.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/utils/index.dart';
import 'package:flutter_wanandroid/widgets/item_article_list.dart';
import 'package:flutter_wanandroid/widgets/refresh_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 广场
class SquareScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return SquareScreenState();
  }
}

class SquareScreenState extends BaseWidgetState<SquareScreen> {
  /// 首页文章列表数据
  List<ArticleBean> _articles = new List();

  /// 是否显示悬浮按钮
  bool _isShowFAB = false;

  /// listview 控制器
  ScrollController _scrollController = new ScrollController();

  /// 页码，从0开始
  int _page = 0;
  RefreshController _refreshController =
      new RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
    this.registerRefreshEvent();
  }

  /// 注册刷新列表事件
  void registerRefreshEvent() {
    Application.eventBus.on<RefreshShareEvent>().listen((event) {
      showLoading().then((value) {
        getSquareList();
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    showLoading().then((value) {
      getSquareList();
    });

    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // getMoreArticleList();
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

  /// 获取文章列表数据
  Future getSquareList() async {
    _page = 0;
    apiService.getSquareList((ArticleModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          showContent().then((value) {
            _refreshController.refreshCompleted(resetFooterState: true);
            setState(() {
              _articles.addAll(model.data.datas);
            });
          });
        } else {
          showEmpty();
        }
      } else {
        showError();
        T.show(msg: model.errorMsg);
      }
    }, (DioError error) {
      showError();
    }, _page);
  }

  /// 获取更多文章列表数据
  Future getMoreSquareList() async {
    _page++;
    apiService.getSquareList((ArticleModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          _refreshController.loadComplete();
          setState(() {
            _articles.addAll(model.data.datas);
          });
        } else {
          _refreshController.loadNoData();
        }
      } else {
        _refreshController.loadFailed();
        T.show(msg: model.errorMsg);
      }
    }, (DioError error) {
      _refreshController.loadFailed();
    }, _page);
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
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: RefreshFooter(),
        controller: _refreshController,
        onRefresh: getSquareList,
        onLoading: getMoreSquareList,
        child: ListView.builder(
          itemBuilder: itemView,
          physics: new AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _articles.length + 1,
        ),
      ),
      floatingActionButton: !_isShowFAB
          ? null
          : FloatingActionButton(
              heroTag: "home",
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                /// 回到顶部时要执行的动画
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 2000), curve: Curves.ease);
              },
            ),
    );
  }

  /// ListView 中每一行的视图
  Widget itemView(BuildContext context, int index) {
    if (index > _articles.length) return null;
    ArticleBean item = _articles[index];
    return ItemArticleList(item: item);
  }

  @override
  void onClickErrorWidget() {
    showLoading().then((value) {
      getSquareList();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
