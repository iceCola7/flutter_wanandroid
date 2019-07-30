import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class BaseWidget extends StatefulWidget {
  BaseWidgetState baseWidgetState;

  @override
  State<StatefulWidget> createState() {
    baseWidgetState = attachState();
    return baseWidgetState;
  }

  BaseWidgetState attachState();
}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T> {
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

  /// 错误页面和空页面的字体粗度
  FontWeight _fontWidget = FontWeight.w600;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _attachBaseAppBar(),
      body: Container(
        color: Colors.white, // 背景颜色
        child: Stack(
          children: <Widget>[
            attachContentWidget(context),
            _attachBaseErrorWidget(),
            _attachBaseLoadingWidget(),
            _attachBaseEmptyWidget()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget attachContentWidget(BuildContext context);

  PreferredSizeWidget _attachBaseAppBar() {
    return PreferredSize(
      child: Offstage(
        offstage: !_isAppBarShow,
        child: attachAppBar(),
      ),
      preferredSize: Size.fromHeight(50),
    );
  }

  /// 导航栏  AppBar
  AppBar attachAppBar();

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
      color: Colors.white,
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
              child: Text(_errorContentMsg,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: _fontWidget,
                  )),
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
                ))
          ],
        ),
      ),
    );
  }

  /// 点击错误页面后展示内容
  void onClickErrorWidget();

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
      child: CupertinoActivityIndicator(
        radius: 15.0,
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
      color: Colors.white,
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
  void setErrorContent(String content) {
    if (content != null) {
      setState(() {
        _errorContentMsg = content;
      });
    }
  }

  /// 设置空页面信息
  void setEmptyContent(String content) {
    if (content != null) {
      setState(() {
        _emptyContentMsg = content;
      });
    }
  }

  /// 设置错误页面图片
  void setErrorImg(String imgPath) {
    if (imgPath != null) {
      setState(() {
        _errorImgPath = imgPath;
      });
    }
  }

  /// 设置空页面图片
  void setEmptyImg(String imgPath) {
    if (imgPath != null) {
      setState(() {
        _emptyImgPath = imgPath;
      });
    }
  }

  /// 设置导航栏显示或者隐藏
  void setAppBarVisible(bool visible) {
    setState(() {
      _isAppBarShow = visible;
    });
  }

  /// 显示展示的内容
  void showContent() {
    setState(() {
      _isEmptyWidgetShow = false;
      _isLoadingWidgetShow = false;
      _isErrorWidgetShow = false;
    });
  }

  /// 显示正在加载
  void showLoading() {
    setState(() {
      _isEmptyWidgetShow = false;
      _isLoadingWidgetShow = true;
      _isErrorWidgetShow = false;
    });
  }

  /// 显示空数据页面
  void showEmpty() {
    setState(() {
      _isEmptyWidgetShow = true;
      _isLoadingWidgetShow = false;
      _isErrorWidgetShow = false;
    });
  }

  /// 显示错误页面
  void showError() {
    setState(() {
      _isEmptyWidgetShow = false;
      _isLoadingWidgetShow = false;
      _isErrorWidgetShow = true;
    });
  }
}
