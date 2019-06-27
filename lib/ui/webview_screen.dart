import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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

  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onStateChanged.listen((state) {
      debugPrint('state:_' + state.type.toString());
      if (state.type == WebViewState.finishLoad) {
        setState(() {
          isLoad = false;
        });
      } else if (state.type == WebViewState.startLoad) {
        setState(() {
          isLoad = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: WebviewScaffold(
        url: widget.url,
        appBar: new AppBar(
          elevation: 0.4,
          title: new Text(widget.title),
          bottom: new PreferredSize(
              child: isLoad
                  ? new LinearProgressIndicator()
                  : new Divider(
                      height: 1.0,
                      color: Theme.of(context).primaryColor,
                    ),
              preferredSize: Size.fromHeight(1.0)),
        ),
        withZoom: false,
        withLocalStorage: true,
        withJavascript: true,
      ),
    );
  }
}
