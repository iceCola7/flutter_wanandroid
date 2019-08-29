import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 封装一个通用的Widget
abstract class BaseWidget extends StatefulWidget {
  BaseWidgetState baseWidgetState;

  @override
  State<StatefulWidget> createState() {
    baseWidgetState = attachState();
    return baseWidgetState;
  }

  BaseWidgetState attachState();
}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  /// 导航栏是否显示
  bool _isAppBarShow = true;

  /// 错误信息是否显示
  bool _isErrorWidgetShow = false;
  String _errorContentMsg = "网络请求失败，请检查您的网络";
  String _errorImgPath = "assets/images/ic_error.png";

  bool _isLoadingWidgetShow = false;

  bool _isEmptyWidgetShow = false;
  String _emptyContentMsg = "暂无数据";
  String _emptyImgPath = "assets/images/ic_empty.png";

  bool _isShowContent = false;

  /// 错误页面和空页面的字体粗度
  FontWeight _fontWidget = FontWeight.w600;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _attachBaseAppBar(),
      body: Container(
        child: Stack(
          children: <Widget>[
            _attachBaseContentWidget(context),
            _attachBaseErrorWidget(),
            _attachBaseLoadingWidget(),
            _attachBaseEmptyWidget()
          ],
        ),
      ),
      floatingActionButton: fabWidget(),
    );
  }

  /// 悬浮按钮
  Widget fabWidget() {
    return null;
  }

  /// 导航栏  AppBar
  AppBar attachAppBar();

  /// 暴露内容视图
  Widget attachContentWidget(BuildContext context);

  /// 点击错误页面后展示内容
  void onClickErrorWidget();

  /// 导航栏 AppBar
  PreferredSizeWidget _attachBaseAppBar() {
    return PreferredSize(
      child: Offstage(
        offstage: !_isAppBarShow,
        child: attachAppBar(),
      ),
      preferredSize: Size.fromHeight(56),
    );
  }

  /// 内容页面
  Widget _attachBaseContentWidget(BuildContext context) {
    return Offstage(
      offstage: !_isShowContent,
      child: attachContentWidget(context),
    );
  }

  /// 错误页面
  Widget _attachBaseErrorWidget() {
    return Offstage(
      offstage: !_isErrorWidgetShow,
      child: attachErrorWidget(),
    );
  }

  /// 暴露的错误页面方法，可以自己重写定制
  Widget attachErrorWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(_errorImgPath),
              width: 120,
              height: 120,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                _errorContentMsg,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: _fontWidget,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: OutlineButton(
                child: Text("重新加载",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: _fontWidget,
                    )),
                onPressed: () => {onClickErrorWidget()},
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 正在加载页面
  Widget _attachBaseLoadingWidget() {
    return Offstage(
      offstage: !_isLoadingWidgetShow,
      child: attachLoadingWidget(),
    );
  }

  /// 暴露的正在加载页面方法，可以自己重写定制
  Widget attachLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
      ),
    );
  }

  /// 数据为空的页面
  Widget _attachBaseEmptyWidget() {
    return Offstage(
      offstage: !_isEmptyWidgetShow,
      child: attachEmptyWidget(),
    );
  }

  /// 暴露的数据为空页面方法，可以自己重写定制
  Widget attachEmptyWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                color: Colors.black12,
                image: AssetImage(_emptyImgPath),
                width: 150,
                height: 150,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(_emptyContentMsg,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: _fontWidget,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 设置错误提示信息
  Future setErrorContent(String content) async {
    if (content != null) {
      setState(() {
        _errorContentMsg = content;
      });
    }
  }

  /// 设置空页面信息
  Future setEmptyContent(String content) async {
    if (content != null) {
      setState(() {
        _emptyContentMsg = content;
      });
    }
  }

  /// 设置错误页面图片
  Future setErrorImg(String imgPath) async {
    if (imgPath != null) {
      setState(() {
        _errorImgPath = imgPath;
      });
    }
  }

  /// 设置空页面图片
  Future setEmptyImg(String imgPath) async {
    if (imgPath != null) {
      setState(() {
        _emptyImgPath = imgPath;
      });
    }
  }

  /// 设置导航栏显示或者隐藏
  Future setAppBarVisible(bool visible) async {
    setState(() {
      _isAppBarShow = visible;
    });
  }

  /// 显示展示的内容
  Future showContent() async {
    setState(() {
      _isShowContent = true;
      _isEmptyWidgetShow = false;
      _isLoadingWidgetShow = false;
      _isErrorWidgetShow = false;
    });
  }

  /// 显示正在加载
  Future showLoading() async {
    setState(() {
      _isShowContent = false;
      _isEmptyWidgetShow = false;
      _isLoadingWidgetShow = true;
      _isErrorWidgetShow = false;
    });
  }

  /// 显示空数据页面
  Future showEmpty() async {
    setState(() {
      _isShowContent = false;
      _isEmptyWidgetShow = true;
      _isLoadingWidgetShow = false;
      _isErrorWidgetShow = false;
    });
  }

  /// 显示错误页面
  Future showError() async {
    setState(() {
      _isShowContent = false;
      _isEmptyWidgetShow = false;
      _isLoadingWidgetShow = false;
      _isErrorWidgetShow = true;
    });
  }
}
