import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/data/model/search_article_model.dart';
import 'package:flutter_wanandroid/utils/index.dart';
import 'package:flutter_wanandroid/widgets/custom_cached_image.dart';
import 'package:flutter_wanandroid/widgets/like_button_widget.dart';

class ItemHotResultList extends StatefulWidget {
  SearchArticleBean item;

  ItemHotResultList({this.item});

  @override
  State<StatefulWidget> createState() {
    return new ItemHotResultListState();
  }
}

class ItemHotResultListState extends State<ItemHotResultList> {
  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    return InkWell(
      onTap: () {
        RouteUtil.toWebView(context, item.title, item.link);
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: <Widget>[
                Offstage(
                  offstage: !item.fresh,
                  child: Container(
                    decoration: new BoxDecoration(
                      border:
                          new Border.all(color: Color(0xFFF44336), width: 0.5),
                      borderRadius: new BorderRadius.vertical(
                          top: Radius.elliptical(2, 2),
                          bottom: Radius.elliptical(2, 2)),
                    ),
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: Text(
                      "新",
                      style: TextStyle(
                          fontSize: 10, color: const Color(0xFFF44336)),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Offstage(
                  offstage: item.tags.length == 0,
                  child: Container(
                    decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.cyan, width: 0.5),
                      borderRadius: new BorderRadius.vertical(
                          top: Radius.elliptical(2, 2),
                          bottom: Radius.elliptical(2, 2)),
                    ),
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: Text(
                      item.tags.length > 0 ? item.tags[0].name : "",
                      style: TextStyle(fontSize: 10, color: Colors.cyan),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Text(
                  item.author,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.left,
                ),
                Expanded(
                  child: Text(
                    item.niceDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Offstage(
                  offstage: item.envelopePic == "",
                  child: Container(
                    width: 100,
                    height: 80,
                    padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
                    child: CustomCachedImage(imageUrl: item.envelopePic),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Html(
                          useRichText: false,
                          defaultTextStyle: TextStyle(fontSize: 16),
                          data: item.title,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                (item.superChapterName.isNotEmpty
                                        ? '${item.superChapterName} / '
                                        : '') +
                                    (item.chapterName.isNotEmpty
                                        ? item.chapterName
                                        : ''),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            InkWell(
                              child: Container(
                                child: LikeButtonWidget(isLike: item.collect),
                              ),
                              onTap: () {
                                addOrCancelCollect(item);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
        ],
      ),
    );
  }

  /// 添加收藏或者取消收藏
  void addOrCancelCollect(item) {
    List<String> cookies = User.singleton.cookie;
    if (cookies == null || cookies.length == 0) {
      T.show(msg: '请先登录~');
    } else {
      if (item.collect) {
        apiService.cancelCollection((BaseModel model) {
          if (model.errorCode == Constants.STATUS_SUCCESS) {
            T.show(msg: '已取消收藏~');
            setState(() {
              item.collect = false;
            });
          } else {
            T.show(msg: '取消收藏失败~');
          }
        }, (DioError error) {
          print(error.response);
        }, item.id);
      } else {
        apiService.addCollection((BaseModel model) {
          if (model.errorCode == Constants.STATUS_SUCCESS) {
            T.show(msg: '收藏成功~');
            setState(() {
              item.collect = true;
            });
          } else {
            T.show(msg: '收藏失败~');
          }
        }, (DioError error) {
          print(error.response);
        }, item.id);
      }
    }
  }
}
