import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/data/model/models.dart';
import 'package:flutter_wanandroid/res/styles.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';

class ComArrowItem extends StatelessWidget {
  /// 数据model
  final ComModel model;

  /// 点击回调函数
  final Function onClick;

  const ComArrowItem(this.model, {Key key, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Material(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          onTap: () {
            if (model.page != null) {
              RouteUtil.push(context, model.page);
            } else if (model.url != null) {
              RouteUtil.toWebView(context, model.title, model.url);
            } else {
              onClick();
            }
          },
          title: new Text(model.title == null ? '' : model.title),
          subtitle: (model.subtitle == null || model.subtitle == '')
              ? null
              : new Text(
                  model.subtitle == null ? '' : model.subtitle,
                  style: new TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
          trailing: new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text(
                model.extra == null ? '' : model.extra,
                style: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
              Offstage(
                offstage: model.isShowArrow == null ? true : !model.isShowArrow,
                child: new Icon(Icons.chevron_right, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      decoration: Decorations.bottom,
    );
  }
}
