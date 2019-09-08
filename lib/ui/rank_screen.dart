import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/rank_model.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/utils/index.dart';
import 'package:flutter_wanandroid/utils/toast_util.dart';
import 'package:flutter_wanandroid/widgets/refresh_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 积分排行榜页面
class RankScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new RankScreenState();
  }
}

class RankScreenState extends BaseWidgetState<RankScreen> {
  /// listview 控制器
  ScrollController _scrollController = new ScrollController();

  /// 页码，从1开始
  int _page = 1;

  List<RankBean> _rankList = new List();

  RefreshController _refreshController =
      new RefreshController(initialRefresh: false);

  /// 获取积分排行榜列表
  Future getRankList() async {
    _page = 1;
    apiService.getRankList((RankModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          showContent();
          _refreshController.refreshCompleted(resetFooterState: true);
          setState(() {
            _rankList.clear();
            _rankList.addAll(model.data.datas);
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

  /// 获取更多积分排行榜列表
  Future getMoreRankList() async {
    _page++;
    apiService.getRankList((RankModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          _refreshController.loadComplete();
          setState(() {
            _rankList.addAll(model.data.datas);
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    showLoading().then((value) {
      getRankList();
    });
  }

  @override
  AppBar attachAppBar() {
    return AppBar(
      title: Text("积分排行榜"),
      elevation: 0,
    );
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
        onRefresh: getRankList,
        onLoading: getMoreRankList,
        child: ListView.builder(
          itemBuilder: itemView,
          physics: new AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _rankList.length,
        ),
      ),
    );
  }

  Widget itemView(BuildContext context, int index) {
    RankBean item = _rankList[index];
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0, 16, 16, 16),
          child: Row(
            children: <Widget>[
              Container(
                width: 60,
                alignment: Alignment.center,
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                ),
              ),
              Expanded(
                child: Text(item.username, style: TextStyle(fontSize: 16.0)),
              ),
              Text(
                item.coinCount.toString(),
                style: TextStyle(fontSize: 14.0, color: Colors.cyan),
              )
            ],
          ),
        ),
        Divider(height: 1.0)
      ],
    );
  }

  @override
  void onClickErrorWidget() {
    showLoading().then((value) {
      getRankList();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
