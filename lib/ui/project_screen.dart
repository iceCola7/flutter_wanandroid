import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/data/model/project_article_model.dart';
import 'package:flutter_wanandroid/data/model/project_tree_model.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
import 'package:flutter_wanandroid/utils/toast_util.dart';
import 'package:flutter_wanandroid/widgets/progress_view.dart';

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
    getProjectTreeList();
  }

  Future<Null> getProjectTreeList() async {
    ApiService().getProjectTreeList((ProjectTreeModel projectTreeModel) {
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
        T.show(msg: projectTreeModel.errorMsg);
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
    showLoading();
    getProjectTreeList();
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

class ProjectArticleScreenState extends State<ProjectArticleScreen> {
  List<ProjectArticleBean> _projectArticleList = new List();

  /// listview 控制器
  ScrollController _scrollController = new ScrollController();

  /// 是否显示悬浮按钮
  bool _isShowFAB = false;
  int _page = 1;

  Future<Null> getProjectArticleList() async {
    _page = 1;
    int _id = widget.id;
    ApiService().getProjectArticleList((ProjectArticleListModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        setState(() {
          _projectArticleList.clear();
          _projectArticleList.addAll(model.data.datas);
        });
      } else {
        T.show(msg: model.errorMsg);
      }
    }, (DioError error) {
      print(error.response);
    }, _id, _page);
  }

  Future<Null> getMoreProjectArticleList() async {
    _page++;
    int _id = widget.id;

    ApiService().getProjectArticleList((ProjectArticleListModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          setState(() {
            _projectArticleList.addAll(model.data.datas);
          });
        } else {
          T.show(msg: "没有更多数据了");
        }
      } else {
        T.show(msg: model.errorMsg);
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

    getProjectArticleList();

    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreProjectArticleList();
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
    if (index < _projectArticleList.length) {
      ProjectArticleBean item = _projectArticleList[index];
      return InkWell(
        onTap: () {
          RouteUtil.toWebView(context, item.title, item.link);
        },
        child: InkWell(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                    child: Container(
                      width: 80,
                      height: 130,
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
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
                          padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                          child: Text(
                            item.title,
                            style: TextStyle(fontSize: 16),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                          child: Text(
                            item.desc,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                item.author,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                item.niceDate,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                          child: InkWell(
                            onTap: () {
                              addOrCancelCollect(item);
                            },
                            child: item.collect
                                ? Image(
                                    image:
                                        AssetImage('assets/images/ic_like.png'),
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
                        )
                      ],
                    ),
                  )
                ],
              ),
              Divider(height: 1),
            ],
          ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        displacement: 15,
        onRefresh: getProjectArticleList,
        child: ListView.builder(
            itemBuilder: itemView,
            physics: new AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: _projectArticleList.length + 1),
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
}
