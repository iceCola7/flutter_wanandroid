import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/data/model/wx_article_model.dart';
import 'package:flutter_wanandroid/data/model/wx_chapters_model.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 公众号页面
class WeChatScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new WeChatScreenState();
  }
}

class WeChatScreenState extends BaseWidgetState<WeChatScreen>
    with TickerProviderStateMixin {
  Color _themeColor = ThemeUtils.currentColorTheme;

  List<WXChaptersBean> _chaptersList = new List();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
    getWXChaptersList();
  }

  Future<Null> getWXChaptersList() async {
    ApiService().getWXChaptersList((WXChaptersModel wxChaptersModel) {
      if (wxChaptersModel.errorCode == Constants.STATUS_SUCCESS) {
        if (wxChaptersModel.data.length > 0) {
          showContent();
          setState(() {
            _chaptersList.addAll(wxChaptersModel.data);
          });
        } else {
          showError();
        }
      } else {
        Fluttertoast.showToast(msg: wxChaptersModel.errorMsg);
      }
    }, (DioError error) {
      print(error.response);
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
    return AppBar(
      title: Text(""),
    );
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    _tabController =
        new TabController(length: _chaptersList.length, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontSize: 16),
            unselectedLabelStyle: TextStyle(fontSize: 16),
            controller: _tabController,
            isScrollable: true,
            tabs: _chaptersList.map((WXChaptersBean item) {
              return Tab(text: item.name);
            }).toList()),
      ),
      body: TabBarView(
          controller: _tabController,
          children: _chaptersList.map((item) {
            return WXArticleScreen(item.id);
          }).toList()),
    );
  }

  @override
  void onClickErrorWidget() {
    showLoading();
    getWXChaptersList();
  }
}

class WXArticleScreen extends StatefulWidget {
  final int id;

  WXArticleScreen(this.id);

  @override
  State<StatefulWidget> createState() {
    return new WXArticleScreenState();
  }
}

class WXArticleScreenState extends State<WXArticleScreen> {
  List<WXArticleBean> _wxArticleList = new List();

  /// listview 控制器
  ScrollController _scrollController = new ScrollController();

  /// 是否显示悬浮按钮
  bool _isShowFAB = false;
  int _page = 1;

  Future<Null> getWXArticleList() async {
    _page = 1;
    int _id = widget.id;
    ApiService().getWXArticleList((WXArticleModel wxArticleModel) {
      if (wxArticleModel.errorCode == Constants.STATUS_SUCCESS) {
        setState(() {
          _wxArticleList.clear();
          _wxArticleList.addAll(wxArticleModel.data.datas);
        });
      } else {
        Fluttertoast.showToast(msg: wxArticleModel.errorMsg);
      }
    }, (DioError error) {
      print(error.response);
    }, _id, _page);
  }

  Future<Null> getMoreWXArticleList() async {
    _page++;
    int _id = widget.id;
    ApiService().getWXArticleList((WXArticleModel wxArticleModel) {
      if (wxArticleModel.errorCode == Constants.STATUS_SUCCESS) {
        if (wxArticleModel.data.datas.length > 0) {
          setState(() {
            _wxArticleList.addAll(wxArticleModel.data.datas);
          });
        } else {
          Fluttertoast.showToast(msg: "没有更多数据了");
        }
      } else {
        Fluttertoast.showToast(msg: wxArticleModel.errorMsg);
      }
    }, (DioError error) {
      print(error.response);
    }, _id, _page);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();

    getWXArticleList();

    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreWXArticleList();
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

  Widget itemView(BuildContext context, int index) {
    if (index < _wxArticleList.length) {
      WXArticleBean item = _wxArticleList[index];
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
                  Text(
                    item.author,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Text(
                      item.niceDate,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                      style: TextStyle(
                        fontSize: 16,
                      ),
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
                      item.superChapterName + " / " + item.chapterName,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  InkWell(
                    child: Container(
                      child: Image(
                        color: Colors.grey[600],
                        image: AssetImage(item.collect
                            ? 'assets/images/ic_like.png'
                            : 'assets/images/ic_like_not.png'),
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
      );
    }
    return null;
  }

  /// 添加收藏或者取消收藏
  void addOrCancelCollect(item) {
    List<String> cookies = User.singleton.cookie;
    if (cookies == null || cookies.length == 0) {
      Fluttertoast.showToast(msg: '请先登录~');
    } else {
      if (item.collect) {
        ApiService().cancelCollection((BaseModel model) {
          if (model.errorCode == Constants.STATUS_SUCCESS) {
            Fluttertoast.showToast(msg: '已取消收藏~');
            setState(() {
              item.collect = false;
            });
          } else {
            Fluttertoast.showToast(msg: '取消收藏失败~');
          }
        }, (DioError error) {
          print(error.response);
        }, item.id);
      } else {
        ApiService().addCollection((BaseModel model) {
          if (model.errorCode == Constants.STATUS_SUCCESS) {
            Fluttertoast.showToast(msg: '收藏成功~');
            setState(() {
              item.collect = true;
            });
          } else {
            Fluttertoast.showToast(msg: '收藏失败~');
          }
        }, (DioError error) {
          print(error.response);
        }, item.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        displacement: 15,
        onRefresh: getWXArticleList,
        child: ListView.separated(
            itemBuilder: itemView,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 0.5,
                color: Colors.grey[600],
              );
            },
            physics: new AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            // 包含轮播和加载更多
            itemCount: _wxArticleList.length + 1),
      ),
      floatingActionButton: !_isShowFAB
          ? null
          : FloatingActionButton(
              heroTag: "wechat",
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
              backgroundColor: ThemeUtils.currentColorTheme,
              onPressed: () {
                /// 回到顶部时要执行的动画
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 2000), curve: Curves.ease);
              },
            ),
    );
  }
}
