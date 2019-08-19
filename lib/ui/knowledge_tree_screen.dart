import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/knowledge_tree_model.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';

import 'knowledge_detail_screen.dart';

/// 知识体系页面
class KnowledgeTreeScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new KnowledgeTreeState();
  }
}

class KnowledgeTreeState extends BaseWidgetState<KnowledgeTreeScreen> {
  List<KnowledgeTreeBean> _list = new List();

  /// listview 控制器
  ScrollController _scrollController = new ScrollController();

  /// 是否显示悬浮按钮
  bool _isShowFAB = false;

  @override
  void initState() {
    super.initState();

    setAppBarVisible(false);

    getKnowledgeTreeList();

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

  Future<Null> getKnowledgeTreeList() async {
    ApiService().getKnowledgeTreeList((KnowledgeTreeModel knowledgeTreeModel) {
      if (knowledgeTreeModel.errorCode == Constants.STATUS_SUCCESS) {
        if (knowledgeTreeModel.data.length > 0) {
          showContent();
          setState(() {
            _list.clear();
            _list.addAll(knowledgeTreeModel.data);
          });
        } else {
          showEmpty();
        }
      }
    }, (DioError error) {
      print(error.response);
      showError();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  AppBar attachAppBar() {
    return AppBar(
      title: Text(""),
    );
  }

  Widget itemView(BuildContext context, int index) {
    if (index < _list.length) {
      KnowledgeTreeBean item = _list[index];
      return InkWell(
        onTap: () {
          RouteUtil.push(context, KnowledgeDetailScreen(new ValueKey(item)));
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 16
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: itemChildrenView(item.children),
                      )
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              )
            ],
          ),
        ),
      );
    }
    return null;
  }

  Widget itemChildrenView(List<KnowledgeTreeChildBean> children) {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    for (var item in children) {
      tiles.add(
        new Text(
          item.name,
          style: TextStyle(color: Color(0xFF757575)),
        ),
      );
    }

    return Wrap(
        spacing: 10,
        runSpacing: 6,
        alignment: WrapAlignment.start,
        children: tiles);
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        displacement: 15,
        onRefresh: getKnowledgeTreeList,
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
            itemCount: _list.length + 1),
      ),
      floatingActionButton: !_isShowFAB
          ? null
          : FloatingActionButton(
              heroTag: "knowledge",
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

  @override
  void onClickErrorWidget() {
    showLoading();
    getKnowledgeTreeList();
  }
}
