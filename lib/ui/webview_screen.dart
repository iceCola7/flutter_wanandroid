import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/res/colors.dart';
import 'package:flutter_wanandroid/res/styles.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView 加载网页页面
class WebViewScreen extends StatefulWidget {
  /// 标题
  String title;

  /// 链接
  String url;

  WebViewScreen({Key key, @required this.title, @required this.url})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new WebViewScreenState();
  }
}

class WebViewScreenState extends State<WebViewScreen> {
  bool isLoad = true;

  @override
  void initState() {
    super.initState();
  }

  void _onPopSelected(String value) {
    String _title = widget.title;
    switch (value) {
      case "browser":
        RouteUtil.launchInBrowser(widget.url, title: _title);
        break;
      case "share":
        String _url = widget.url;
        Share.share('$_title : $_url');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.4,
        title: new Text(widget.title),
        bottom: new PreferredSize(
            child: isLoad
                ? SizedBox(height: 1.0, child: new LinearProgressIndicator())
                : Divider(height: 1.0),
            preferredSize: Size.fromHeight(1.0)),
        actions: <Widget>[
          new PopupMenuButton(
            padding: const EdgeInsets.all(0.0),
            onSelected: _onPopSelected,
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                  value: "browser",
                  child: ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      dense: false,
                      title: new Container(
                        alignment: Alignment.center,
                        child: new Row(
                          children: <Widget>[
                            Icon(
                              Icons.language,
                              color: Colours.gray_66,
                              size: 22.0,
                            ),
                            Gaps.hGap10,
                            Text('浏览器打开')
                          ],
                        ),
                      ))),
              new PopupMenuItem<String>(
                  value: "share",
                  child: ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      dense: false,
                      title: new Container(
                        alignment: Alignment.center,
                        child: new Row(
                          children: <Widget>[
                            Icon(
                              Icons.share,
                              color: Colours.gray_66,
                              size: 22.0,
                            ),
                            Gaps.hGap10,
                            Text('分享')
                          ],
                        ),
                      ))),
            ],
          )
        ],
      ),
      body: new WebView(
        onWebViewCreated: (WebViewController webViewController) {},
        onPageFinished: (String url) {
          debugPrint(url);
          setState(() {
            isLoad = false;
          });
        },
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
