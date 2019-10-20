import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/history_model.dart';
import 'package:flutter_wanandroid/data/model/hot_word_model.dart';
import 'package:flutter_wanandroid/ui/base_widget.dart';
import 'package:flutter_wanandroid/ui/hot_result_screen.dart';
import 'package:flutter_wanandroid/utils/common_util.dart';
import 'package:flutter_wanandroid/utils/db_util.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
import 'package:flutter_wanandroid/utils/toast_util.dart';

/// 搜索页面
class HotWordScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new HotWordScreenState();
  }
}

class HotWordScreenState extends BaseWidgetState<HotWordScreen> {
  TextEditingController editingController;

  FocusNode focusNode = new FocusNode();
  List<Widget> actions = new List();

  String keyword = "";

  List<HotWordBean> _hotWordList = new List();

  var db = DatabaseUtil();

  List<HistoryBean> _historyList = new List();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    showLoading();
    getSearchHotList();
    getHistoryList();

    editingController = new TextEditingController(text: keyword);
    editingController.addListener(() {
      if (editingController.text == null || editingController.text == "") {
        setState(() {
          actions = [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  textChanged();
                })
          ];
        });
      } else {
        setState(() {
          actions = [
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  editingController.clear();
                  textChanged();
                }),
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  textChanged();
                })
          ];
        });
      }
    });
  }

  void textChanged() {
    focusNode.unfocus();
    if (editingController.text == null || editingController.text == "") {
    } else {
      saveHistory(editingController.text).then((value) {
        RouteUtil.push(context, HotResultScreen(editingController.text));
      });
    }
  }

  /// 保存搜索记录
  Future saveHistory(String text) async {
    int _id = -1;
    _historyList.forEach((bean) {
      if (bean.name == text) _id = bean.id;
    });
    if (_id != -1) await db.deleteById(_id);
    HistoryBean bean = HistoryBean();
    bean.name = text;
    await db.insertItem(bean);
    await getHistoryList();
  }

  /// 获取历史搜索记录
  Future getHistoryList() async {
    var list = await db.queryList();
    setState(() {
      _historyList.clear();
      _historyList.addAll(HistoryBean.fromMapList(list));
    });
    print(list.toString());
  }

  /// 获取搜索热词
  Future getSearchHotList() async {
    apiService.getSearchHotList((HotWordModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        showContent();
        setState(() {
          _hotWordList.clear();
          _hotWordList.addAll(model.data);
        });
      } else {
        showError();
        T.show(msg: model.errorMsg);
      }
    }, (DioError error) {
      showError();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  AppBar attachAppBar() {
    return AppBar(
      elevation: 0.4,
      title: TextField(
        autofocus: false,
        style: TextStyle(color: Colors.white),
        decoration: new InputDecoration(
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
          hintText: "发现更多干货",
        ),
        focusNode: focusNode,
        controller: editingController,
      ),
      actions: actions,
    );
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: new SingleChildScrollView(
        child: contentView(_hotWordList),
      ),
    );
  }

  @override
  void onClickErrorWidget() {
    showLoading();
    getSearchHotList();
  }

  Widget contentView(List<HotWordBean> list) {
    List<Widget> widgets = new List();
    for (HotWordBean item in list) {
      widgets.add(new InkWell(
        child: new Chip(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          label: new Text(
            item.name,
            style: TextStyle(
                fontSize: 14.0,
                color: CommonUtil.randomColor(),
                fontStyle: FontStyle.italic),
          ),
          labelPadding: EdgeInsets.only(left: 3.0, right: 3.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        onTap: () {
          saveHistory(item.name).then((value) {
            RouteUtil.push(context, HotResultScreen(item.name));
          });
        },
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            "热门搜索",
            style: TextStyle(fontSize: 16.0, color: Colors.cyan),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Wrap(
            spacing: 10,
            runSpacing: 4,
            alignment: WrapAlignment.start,
            children: widgets,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "搜索历史",
                  style: TextStyle(fontSize: 16.0, color: Colors.cyan),
                ),
              ),
              Container(
                child: InkWell(
                  child: Text(
                    "清空",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  onTap: () {
                    db.clear();
                    setState(() {
                      _historyList.clear();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            itemBuilder: itemHistoryView,
            physics: new AlwaysScrollableScrollPhysics(),
            itemCount: _historyList.length),
      ],
    );
  }

  Widget itemHistoryView(BuildContext context, int index) {
    HistoryBean item = _historyList[index];
    return InkWell(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      RouteUtil.push(context, HotResultScreen(item.name));
                    },
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: InkWell(
                    onTap: () {
                      db.deleteById(item.id);
                      setState(() {
                        _historyList.removeAt(index);
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.grey[600],
                      size: 16,
                    ),
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
}
