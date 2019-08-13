import 'package:flutter/material.dart';

/// 下拉刷新、加载更多 ListView
class RefreshLoadListView<T> extends StatefulWidget {
  Function loadMore;
  Function refresh;
  List<T> lists;
  Function listBuilder;

  //传入count,则可自行构建不同的listBuilder
  int itemCount;

  RefreshLoadListView(
      {Key key,
      @required this.lists,
      this.loadMore,
      this.refresh,
      @required this.listBuilder,
      @required this.itemCount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => RefreshLoadListViewState();
}

class RefreshLoadListViewState extends State<RefreshLoadListView> {
  //下拉刷新触发距离
  static const double DISPLACEMENT = 40.0;

  //是否显示正在加载
  bool _showLoading = false;

  ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(RefreshLoadListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lists == widget.lists && oldWidget.lists.isNotEmpty) {
      _showLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_showLoading && widget.lists.isNotEmpty) {
          setState(() {
            _showLoading = true;
          });
          _loadMore();
        }
      }
    });
  }

  _refresh() {
    if (widget.refresh != null) {
      widget.refresh();
      setState(() {
        _showLoading = false;
      });
    }
  }

  _loadMore() {
    if (widget.loadMore != null) {
      widget.loadMore();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lists == null || widget.lists.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      int _itemCount =
          widget.itemCount > 0 ? widget.itemCount + 1 : widget.lists.length + 1;
      return RefreshIndicator(
        onRefresh: () async {
          await _refresh();
        },
        displacement: DISPLACEMENT,
        child: ListView.builder(
          itemCount: _itemCount,
          itemBuilder: (context, index) {
            if (index == _itemCount - 1) {
              return _showLoading ? _loadingWidget() : _noMoreWidget();
            } else {
              return widget.listBuilder(context, index);
            }
          },
          controller: _scrollController,
        ),
      );
    }
  }

  Widget _loadingWidget() {
    return Offstage(
        offstage: false,
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Center(
            child: new CircularProgressIndicator(),
          ),
        ));
  }

  Widget _noMoreWidget() {
    return Offstage(
        offstage: false,
        child: Center(
            child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Text("没有更多啦~"))));
  }
}
