import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/data/model/knowledge_detail_model.dart';
import 'package:flutter_wanandroid/data/model/knowledge_tree_model.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
import 'package:flutter_wanandroid/utils/toast_util.dart';
import 'package:flutter_wanandroid/widgets/progress_view.dart';
import 'package:flutter_wanandroid/widgets/refresh_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 知识体系详情页面
class KnowledgeDetailScreen extends StatefulWidget {
  KnowledgeTreeBean bean;

  KnowledgeDetailScreen(ValueKey<KnowledgeTreeBean> key) : super(key: key) {
    this.bean = key.value;
  }

  @override
  State<StatefulWidget> createState() {
    return KnowledgeDetailScreenState();
  }
}

class KnowledgeDetailScreenState extends State<KnowledgeDetailScreen>
    with TickerProviderStateMixin {
  KnowledgeTreeBean bean;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    bean = widget.bean;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController =
        new TabController(length: bean.children.length, vsync: this);
    return new Scaffold(
      appBar: new AppBar(
        title: Text(bean.name),
        bottom: new TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontSize: 16),
            unselectedLabelStyle: TextStyle(fontSize: 16),
            controller: _tabController,
            isScrollable: true,
            tabs: bean.children.map((KnowledgeTreeChildBean item) {
              return Tab(text: item.name);
            }).toList()),
      ),
      body: TabBarView(
          controller: _tabController,
          children: bean.children.map((item) {
            return KnowledgeArticleScreen(item.id);
          }).toList()),
    );
  }
}

class KnowledgeArticleScreen extends BaseWidget {
  final int id;

  KnowledgeArticleScreen(this.id);

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return KnowledgeArticleScreenState();
  }
}

class KnowledgeArticleScreenState
    extends BaseWidgetState<KnowledgeArticleScreen> {
  List<KnowledgeDetailChild> _list = new List();

  ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 0;

  /// 是否显示悬浮按钮
  bool _isShowFAB = false;

  RefreshController _refreshController =
      new RefreshController(initialRefresh: false);

  Future getKnowledgeDetailList() async {
    _page = 0;
    int _id = widget.id;
    apiService.getKnowledgeDetailList((KnowledgeDetailModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          showContent();
          _refreshController.refreshCompleted(resetFooterState: true);
          setState(() {
            _list.clear();
            _list.addAll(model.data.datas);
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
    }, _page, _id);
  }

  Future getMoreKnowledgeDetailList() async {
    _page++;
    int _id = widget.id;
    apiService.getKnowledgeDetailList((KnowledgeDetailModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          _refreshController.loadComplete();
          setState(() {
            _list.addAll(model.data.datas);
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
    }, _page, _id);
  }

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    showLoading().then((value) {
      getKnowledgeDetailList();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // getMoreKnowledgeDetailList();
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
    return new AppBar(title: Text(""));
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
        onRefresh: getKnowledgeDetailList,
        onLoading: getMoreKnowledgeDetailList,
        child: ListView.builder(
          itemBuilder: itemView,
          physics: new AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _list.length,
        ),
      ),
      floatingActionButton: !_isShowFAB
          ? null
          : FloatingActionButton(
              heroTag: "knowledge_detail",
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
      getKnowledgeDetailList();
    });
  }

  Widget itemView(BuildContext context, int index) {
    if (index < _list.length) {
      KnowledgeDetailChild item = _list[index];

      return InkWell(
        onTap: () {
          RouteUtil.toWebView(context, item.title, item.link);
        },
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Offstage(
                  offstage: item.envelopePic == '',
                  child: Container(
                    width: 100,
                    height: 80,
                    padding: EdgeInsets.fromLTRB(16, 10, 8, 10),
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
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: Row(
                          children: <Widget>[
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
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                item.title,
                                maxLines: 2,
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                item.chapterName,
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
                )
              ],
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
        apiService.cancelCollection((BaseModel model) {
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
        apiService.addCollection((BaseModel model) {
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
}
