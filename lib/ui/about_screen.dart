import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/data/model/models.dart';
import 'package:flutter_wanandroid/res/styles.dart';
import 'package:flutter_wanandroid/utils/utils.dart';
import 'package:flutter_wanandroid/widgets/com_item.dart';

/// 关于界面
class AboutScreen extends StatelessWidget {
  ComModel version =
      new ComModel(title: '版本号', extra: AppConfig.version, isShowArrow: false);
  ComModel github = new ComModel(
      title: 'GitHub',
      url: 'https://github.com/iceCola7/WanAndroid',
      extra: 'github.com/iceCola7',
      isShowArrow: true);
  ComModel copyright =
      new ComModel(title: '版权声明', extra: '仅作个人及非商业用途', isShowArrow: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("关于"),
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 180.0,
            alignment: Alignment.center,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Card(
                  color: Theme.of(context).primaryColor,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0))),
                  child: new Image.asset(
                    Utils.getImgPath('ic_launcher_news'),
                    width: 72.0,
                    fit: BoxFit.fill,
                    height: 72.0,
                  ),
                ),
                Gaps.vGap10,
                new Text(
                  AppConfig.appName,
                  style: new TextStyle(fontSize: 20),
                ),
              ],
            ),
            decoration: new BoxDecoration(
              // color: Colors.white,
              border: new Border(
                  bottom: BorderSide(width: 0.5, color: Colors.grey[600])),
            ),
          ),
          new ComArrowItem(version),
          new ComArrowItem(github),
          new ComArrowItem(
            copyright,
            onClick: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('版权声明'),
                        content: Text(
                            ('本App所使用的所有API均由 玩Android（www.wanandroid.com） 网站提供，仅供学习交流，不可用于任何商业用途。')),
                      ));
            },
          ),
        ],
      ),
    );
  }
}
