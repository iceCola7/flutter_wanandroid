import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/event/refresh_share_event.dart';
import 'package:flutter_wanandroid/res/styles.dart';
import 'package:flutter_wanandroid/utils/toast_util.dart';
import 'package:flutter_wanandroid/widgets/loading_dialog.dart';

/// 分享文章页面
class ShareArticleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShareArticleScreenState();
  }
}

class ShareArticleScreenState extends State<ShareArticleScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _linkController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _linkFocusNode = FocusNode();

  String title = '';
  String link = '';

  Future _shareArticle() async {
    title = _titleController.text;
    link = _linkController.text;
    if (title.isEmpty) {
      T.show(msg: '请输入文章标题');
      return;
    }
    if (link.isEmpty) {
      T.show(msg: '请输入文章链接');
      return;
    }
    _showLoading(context);
    var params = {
      'title': title,
      'link': link,
    };
    apiService.shareArticle((BaseModel model) {
      _dismissLoading(context);
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        T.show(msg: '分享成功');
        Application.eventBus.fire(new RefreshShareEvent());
        Navigator.of(context).pop();
      } else {
        T.show(msg: model.errorMsg);
      }
    }, (DioError error) {
      _dismissLoading(context);
    }, params);
  }

  /// 显示Loading
  _showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return new LoadingDialog(
            outsideDismiss: false,
            loadingText: "正在提交...",
          );
        });
  }

  /// 隐藏Loading
  _dismissLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0.4,
            title: new Text("分享文章"),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  this._shareArticle();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Text("分享"),
                ),
              )
            ],
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("文章标题", style: TextStyle(fontSize: 16)),
                Gaps.vGap10,
                TextField(
                  focusNode: _titleFocusNode,
                  autofocus: false,
                  controller: _titleController,
                  decoration: InputDecoration.collapsed(
                    hintText: "100字以内",
                  ),
                  maxLines: 3,
                ),
                Gaps.vGap10,
                Text("文章链接", style: TextStyle(fontSize: 16)),
                Gaps.vGap10,
                TextField(
                  focusNode: _linkFocusNode,
                  autofocus: false,
                  controller: _linkController,
                  decoration: InputDecoration.collapsed(
                    hintText: "例如：https://www.wanandroid.com",
                  ),
                  maxLines: 3,
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Text(
                  "1. 只要是任何好文都可以分享哈，并不一定要是原创！投递的文章会进入广场 tab;"
                  "\n2. CSDN，掘金，简书等官方博客站点会直接通过，不需要审核;"
                  "\n3. 其他个人站点会进入审核阶段，不要投递任何无效链接，测试的请尽快删除，否则可能会对你的账号产生一定影响;"
                  "\n4. 目前处于测试阶段，如果你发现500等错误，可以向我提交日志，让我们一起使网站变得更好。"
                  "\n5. 由于本站只有我一个人开发与维护，会尽力保证24小时内审核，当然有可能哪天太累，会延期，请保持佛系...",
                  style: TextStyle(fontSize: 12),
                ),
                Gaps.vGap10,
                Gaps.vGap10,
              ],
            ),
          ),
        ));
  }
}
