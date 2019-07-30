import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/data/model/collection_model.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CollectScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new CollectScreenState();
  }
}

class CollectScreenState extends BaseWidgetState<CollectScreen> {
  List<CollectionBean> _collectList = new List();

  /// listview 控制器
  ScrollController _scrollController = new ScrollController();

  /// 是否显示悬浮按钮
  bool _isShowFAB = false;

  /// 页码，从0开始
  int _page = 0;

  @override
  void initState() {
    super.initState();

    showLoading();
    getCollectionList();

    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreCollectionList();
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

  /// 获取收藏文章列表
  Future<Null> getCollectionList() async {
    _page = 0;
    ApiService().getCollectionList((CollectionModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          showContent();
          setState(() {
            _collectList.clear();
            _collectList.addAll(model.data.datas);
          });
        } else {
          showEmpty();
        }
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: model.errorMsg);
      }
    }, (DioError error) {
      print(error.response);
      setState(() {
        showError();
      });
    }, _page);
  }

  /// 获取更多文章列表
  Future<Null> getMoreCollectionList() async {
    _page++;
    ApiService().getCollectionList((CollectionModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          showContent();
          setState(() {
            _collectList.addAll(model.data.datas);
          });
        } else {
          Fluttertoast.showToast(msg: "没有更多数据了");
        }
      } else {
        Fluttertoast.showToast(msg: model.errorMsg);
      }
    }, (DioError error) {
      print(error.response);
      setState(() {
        showError();
      });
    }, _page);
  }

  @override
  AppBar attachAppBar() {
    return AppBar(
      title: Text("收藏"),
    );
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        displacement: 15,
        onRefresh: getCollectionList,
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
            // 包含轮播和加载更多
            itemCount: _collectList.length + 1),
      ),
      floatingActionButton: !_isShowFAB
          ? null
          : FloatingActionButton(
              heroTag: "collect",
              child: Icon(Icons.arrow_upward),
              backgroundColor: ThemeUtils.currentColorTheme,
              onPressed: () {
                /// 回到顶部时要执行的动画
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 2000), curve: Curves.ease);
              },
            ),
    );
  }

  Widget itemView(BuildContext context, int index) {
    if (index < _collectList.length) {
      CollectionBean item = _collectList[index];
      return InkWell(
        onTap: () {
          RouteUtil.toWebView(context, item.title, item.link);
        },
        child: Row(
          children: <Widget>[
            Offstage(
              offstage: item.envelopePic == '',
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(16, 10, 8, 10),
                child: new Image.network(
                  item.envelopePic,
                  width: 90,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          item.author,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            item.niceDate,
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                              color: const Color(0xFF3D4E5F),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            item.chapterName,
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        InkWell(
                          child: Container(
                            child: Image(
                              // color: Colors.black12,
                              image: AssetImage('assets/images/ic_like.png'),
                              width: 24,
                              height: 24,
                            ),
                          ),
                          onTap: () {
                            cancelCollect(index, item);
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
      );
    }
    return null;
  }

  /// 取消收藏
  void cancelCollect(index, item) {
    List<String> cookies = User.singleton.cookie;
    if (cookies == null) {
      Fluttertoast.showToast(msg: '请先登录~');
    } else {
      ApiService().cancelCollection((BaseModel model) {
        if (model.errorCode == Constants.STATUS_SUCCESS) {
          Fluttertoast.showToast(msg: '已取消收藏~');
          setState(() {
            _collectList.removeAt(index);
          });
        } else {
          Fluttertoast.showToast(msg: '取消收藏失败~');
        }
      }, (DioError error) {
        print(error.response);
      }, item.id);
    }
  }

  @override
  void onClickErrorWidget() {
    showLoading();
    getCollectionList();
  }
}
