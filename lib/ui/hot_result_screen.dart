import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/data/model/search_article_model.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
import 'package:flutter_wanandroid/utils/toast_util.dart';
import 'package:flutter_wanandroid/widgets/progress_view.dart';
import 'package:flutter_wanandroid/widgets/refresh_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 热词搜索页面
class HotResultScreen extends BaseWidget {
  String keyword;

  HotResultScreen(this.keyword);

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new HotResultScreenState();
  }
}

class HotResultScreenState extends BaseWidgetState<HotResultScreen> {
  List<SearchArticleBean> _searchArticleList = new List();

  /// listview 控制器
  ScrollController _scrollController = new ScrollController();

  /// 是否显示悬浮按钮
  bool _isShowFAB = false;

  int _page = 0;

  RefreshController _refreshController =
      new RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    showLoading();
    getSearchArticleList();

    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // getMoreSearchArticleList();
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
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<Null> getSearchArticleList() async {
    _page = 0;
    ApiService().getSearchArticleList((SearchArticleModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          showContent();
          _refreshController.refreshCompleted(resetFooterState: true);
          setState(() {
            _searchArticleList.clear();
            _searchArticleList.addAll(model.data.datas);
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
    }, _page, widget.keyword);
  }

  Future<Null> getMoreSearchArticleList() async {
    _page++;
    ApiService().getSearchArticleList((SearchArticleModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          _refreshController.loadComplete();
          setState(() {
            _searchArticleList.addAll(model.data.datas);
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
    }, _page, widget.keyword);
  }

  @override
  AppBar attachAppBar() {
    return AppBar(title: Text(widget.keyword));
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
        onRefresh: getSearchArticleList,
        onLoading: getMoreSearchArticleList,
        child: ListView.builder(
          itemBuilder: itemView,
          physics: new AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _searchArticleList.length,
        ),
      ),
      floatingActionButton: !_isShowFAB
          ? null
          : FloatingActionButton(
              heroTag: "hot",
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
    if (index < _searchArticleList.length) {
      SearchArticleBean item = _searchArticleList[index];

      return InkWell(
        onTap: () {
          RouteUtil.toWebView(context, item.title, item.link);
        },
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: <Widget>[
                  Offstage(
                    offstage: !item.fresh,
                    child: Container(
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            color: Color(0xFFF44336), width: 0.5),
                        borderRadius: new BorderRadius.vertical(
                            top: Radius.elliptical(2, 2),
                            bottom: Radius.elliptical(2, 2)),
                      ),
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: Text(
                        "新",
                        style: TextStyle(
                            fontSize: 10, color: const Color(0xFFF44336)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: item.tags.length == 0,
                    child: Container(
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.cyan, width: 0.5),
                        borderRadius: new BorderRadius.vertical(
                            top: Radius.elliptical(2, 2),
                            bottom: Radius.elliptical(2, 2)),
                      ),
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: Text(
                        item.tags.length > 0 ? item.tags[0].name : "",
                        style: TextStyle(fontSize: 10, color: Colors.cyan),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Text(
                    item.author,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Text(
                      item.niceDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Offstage(
                    offstage: item.envelopePic == "",
                    child: Container(
                      width: 100,
                      height: 80,
                      padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: item.envelopePic,
                        placeholder: (context, url) => new ProgressView(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Html(
                            useRichText: false,
                            defaultTextStyle: TextStyle(fontSize: 16),
                            data: item.title,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  (item.superChapterName.isNotEmpty
                                          ? '${item.superChapterName} / '
                                          : '') +
                                      (item.chapterName.isNotEmpty
                                          ? item.chapterName
                                          : ''),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  child: item.collect
                                      ? Image(
                                          image: AssetImage(
                                              'assets/images/ic_like.png'),
                                          width: 24,
                                          height: 24,
                                        )
                                      : Image(
                                          color: Colors.grey[600],
                                          image: AssetImage(
                                              'assets/images/ic_like_not.png'),
                                          width: 24,
                                          height: 24,
                                        ),
                                ),
                                onTap: () {
                                  addOrCancelCollect(item);
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
          ],
        ),
      );
    }
    return null;
  }

  /// 添加收藏或者取消收藏
  void addOrCancelCollect(item) {
    List<String> cookies = User.singleton.cookie;
    if (cookies == null || cookies.length == 0) {
      T.show(msg: '请先登录~');
    } else {
      if (item.collect) {
        ApiService().cancelCollection((BaseModel model) {
          if (model.errorCode == Constants.STATUS_SUCCESS) {
            T.show(msg: '已取消收藏~');
            setState(() {
              item.collect = false;
            });
          } else {
            T.show(msg: '取消收藏失败~');
          }
        }, (DioError error) {
          print(error.response);
        }, item.id);
      } else {
        ApiService().addCollection((BaseModel model) {
          if (model.errorCode == Constants.STATUS_SUCCESS) {
            T.show(msg: '收藏成功~');
            setState(() {
              item.collect = true;
            });
          } else {
            T.show(msg: '收藏失败~');
          }
        }, (DioError error) {
          print(error.response);
        }, item.id);
      }
    }
  }

  @override
  void onClickErrorWidget() {
    showLoading();
    getSearchArticleList();
  }
}
