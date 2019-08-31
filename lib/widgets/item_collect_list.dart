import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/data/model/collection_model.dart';
import 'package:flutter_wanandroid/utils/index.dart';
import 'package:flutter_wanandroid/widgets/custom_cached_image.dart';
import 'package:flutter_wanandroid/widgets/like_button_widget.dart';

class ItemCollectList extends StatefulWidget {
  CollectionBean item;

  /// 收藏的回调函数
  Function onCollectCallback;

  ItemCollectList({this.item, this.onCollectCallback});

  @override
  State<StatefulWidget> createState() {
    return new ItemCollectListState();
  }
}

class ItemCollectListState extends State<ItemCollectList> {
  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    return InkWell(
      onTap: () {
        RouteUtil.toWebView(context, item.title, item.link);
      },
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Offstage(
                offstage: item.envelopePic == '',
                child: Container(
                  width: 100,
                  height: 80,
                  padding: EdgeInsets.fromLTRB(16, 10, 8, 10),
                  child: CustomCachedImage(imageUrl: item.envelopePic),
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Row(
                        children: <Widget>[
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
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 2,
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              item.chapterName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          InkWell(
                            child: Container(
                              child: LikeButtonWidget(isLike: true),
                            ),
                            onTap: () {
                              cancelCollect(item);
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Divider(height: 1),
        ],
      ),
    );
  }

  /// 取消收藏
  void cancelCollect(item) {
    List<String> cookies = User.singleton.cookie;
    if (cookies == null || cookies.length == 0) {
      T.show(msg: '请先登录~');
    } else {
      apiService.cancelCollection((BaseModel model) {
        if (model.errorCode == Constants.STATUS_SUCCESS) {
          T.show(msg: '已取消收藏~');
          widget.onCollectCallback(true);
        } else {
          T.show(msg: '取消收藏失败~');
          widget.onCollectCallback(false);
        }
      }, (DioError error) {
        print(error.response);
      }, item.id);
    }
  }
}
