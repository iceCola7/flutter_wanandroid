import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/event/refresh_todo_event.dart';
import 'package:flutter_wanandroid/widgets/loading_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 新增或编辑TODO
class TodoAddScreen extends StatefulWidget {
  /// 类型：0:新增  1:编辑  2:查看
  final int typeKey;

  TodoAddScreen(this.typeKey);

  @override
  State<StatefulWidget> createState() {
    return TodoAddScreenSate();
  }
}

class TodoAddScreenSate extends State<TodoAddScreen> {
  String toolbarTitle = "";
  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _detailFocusNode = FocusNode();

  String title = ''; // 标题
  String content = ''; // 详情
  int priorityValue = 0; // 优先级  0:一般  1:重要
  String selectedDate = ''; // 选择日期

  @override
  void initState() {
    super.initState();

    toolbarTitle =
        widget.typeKey == 0 ? '新增' : (widget.typeKey == 1 ? '编辑' : '查看');

    selectedDate = DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM-dd');
  }

  /// 构造分割线
  Widget buildDivider() {
    return Container(
      height: 0.5,
      color: Colors.black26,
    );
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
            title: new Text(toolbarTitle),
          ),
          body: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "标题：",
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: _titleFocusNode,
                          autofocus: true,
                          controller: _titleController,
                          decoration: InputDecoration.collapsed(
                            hintText: "请输入标题",
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                buildDivider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "详情：",
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: _detailFocusNode,
                          autofocus: false,
                          controller: _detailController,
                          decoration: InputDecoration.collapsed(
                            hintText: "请输入详情",
                          ),
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                buildDivider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "优先级：",
                        style: TextStyle(fontSize: 16),
                      ),
                      Radio(
                        value: 0,
                        groupValue: this.priorityValue,
                        activeColor: Color(0xFF00BCD4),
                        onChanged: (value) {
                          setState(() {
                            this.priorityValue = value;
                          });
                        },
                      ),
                      Text('一般'),
                      Radio(
                        value: 1,
                        groupValue: this.priorityValue,
                        activeColor: Color(0xFF00BCD4),
                        onChanged: (value) {
                          setState(() {
                            this.priorityValue = value;
                          });
                        },
                      ),
                      Text('重要'),
                    ],
                  ),
                ),
                buildDivider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: InkWell(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate: new DateTime.now()
                            .subtract(new Duration(days: 30)), // 减 30 天
                        lastDate: new DateTime.now()
                            .add(new Duration(days: 30)), // 加 30 天
                      ).then((val) {
                        setState(() {
                          selectedDate =
                              DateUtil.formatDate(val, format: 'yyyy-MM-dd');
                        });
                      }).catchError((err) {
                        print(err);
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "日期：",
                          style: TextStyle(fontSize: 16),
                        ),
                        Expanded(
                          child: Text(
                            selectedDate,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
                buildDivider(),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.all(16.0),
                          elevation: 0.5,
                          child: Text("保存"),
                          color: Color(0xFF00BCD4),
                          textColor: Colors.white,
                          onPressed: () {
                            _saveTodo();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  /// 显示Loading
  _showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return new LoadingDialog(
            outsideDismiss: false,
            loadingText: "正在保存...",
          );
        });
  }

  /// 隐藏Loading
  _dismissLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// 保存TODO
  Future<Null> _saveTodo() async {
    title = _titleController.text;
    content = _detailController.text;

    if (title == '') {
      Fluttertoast.showToast(msg: '请输入标题');
      return;
    }
    if (content == '') {
      Fluttertoast.showToast(msg: '请输入详情');
      return;
    }
    _showLoading(context);
    var params = {
      'title': title,
      'content': content,
      'date': selectedDate,
      'type': 0
    };
    ApiService().addTodo((BaseModel model) {
      _dismissLoading(context);
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        Fluttertoast.showToast(msg: '保存成功');
        Application.eventBus.fire(new RefreshTodoEvent());
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(msg: model.errorMsg);
      }
    }, (DioError error) {
      _dismissLoading(context);
      print(error.response);
    }, params);
  }
}
