import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/hot_word_model.dart';
import 'package:flutter_wanandroid/utils/common_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HotWordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HotWordScreenState();
  }
}

class HotWordScreenState extends State<HotWordScreen> {
  TextEditingController editingController;

  FocusNode focusNode = new FocusNode();
  List<Widget> actions = new List();

  String keyword = "";

  List<HotWordBean> _hotWordList = new List();

  @override
  void initState() {
    super.initState();

    getSearchHotList();

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
    } else {}
  }

  Future<Null> getSearchHotList() async {
    ApiService().getSearchHotList((HotWordModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        setState(() {
          _hotWordList.clear();
          _hotWordList.addAll(model.data);
        });
      } else {
        Fluttertoast.showToast(msg: model.errorMsg);
      }
    }, (DioError error) {
      print(error.response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: new InputDecoration(
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
              hintText: "发现更多干货"),
          focusNode: focusNode,
          controller: editingController,
        ),
        actions: actions,
      ),
      body: contentView(_hotWordList),
    );
  }

  Widget contentView(List<HotWordBean> list) {
    List<Widget> widgets = new List();
    for (HotWordBean item in list) {
      widgets.add(new InkWell(
        child: new Chip(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Color(0xfff1f1f1),
          label: new Text(
            item.name,
            style: TextStyle(
                fontSize: 14.0,
                color: CommonUtil.randomColor(),
                fontStyle: FontStyle.italic),
          ),
          labelPadding: EdgeInsets.only(left: 3.0, right: 3.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)),
        ),
        onTap: () {},
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            "热门搜索",
            style: TextStyle(fontSize: 16.0, color: const Color(0xFF00BCD4)),
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
        )
      ],
    );
  }
}
