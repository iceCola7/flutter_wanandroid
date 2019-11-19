import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/ui/knowledge_tree_screen.dart';
import 'package:flutter_wanandroid/ui/navigation_screen.dart';

/// 体系页面
class SystemScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return SystemScreenState();
  }
}

class SystemScreenState extends BaseWidgetState<SystemScreen>
    with TickerProviderStateMixin {
  var _list = ["体系", "导航"];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    showContent();
  }

  @override
  AppBar attachAppBar() {
    return AppBar(title: Text(""));
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    _tabController = new TabController(length: _list.length, vsync: this);
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
              isScrollable: false,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: _list.map((item) {
                return Tab(text: item);
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: [KnowledgeTreeScreen(), NavigationScreen()]),
          )
        ],
      ),
    );
  }

  @override
  void onClickErrorWidget() {}

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
