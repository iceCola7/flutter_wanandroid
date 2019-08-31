import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_wanandroid/data/model/todo_list_model.dart';
import 'package:flutter_wanandroid/ui/todo_add_screen.dart';
import 'package:flutter_wanandroid/utils/index.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ItemTodoList extends StatefulWidget {
  /// TODO实体
  TodoBean item;

  /// 滑动删除Controller
  SlidableController slidableController;

  bool isShowSuspension = false;

  /// 待办类型
  int todoType;

  /// 是否是待办 true:待办  false:已完成
  bool isTodo = true;

  /// 更新TODO
  Function updateTodoCallback;

  /// 删除TODO
  Function deleteItemCallback;

  ItemTodoList(
      {this.isTodo,
      this.item,
      this.slidableController,
      this.isShowSuspension,
      this.todoType,
      this.updateTodoCallback,
      this.deleteItemCallback});

  @override
  State<StatefulWidget> createState() {
    return new ItemTodoListState();
  }
}

class ItemTodoListState extends State<ItemTodoList> {
  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    bool isShowSuspension = widget.isShowSuspension;
    SlidableController slidableController = widget.slidableController;
    int todoType = widget.todoType;
    bool isTodo = widget.isTodo;

    return StickyHeader(
      header: Offstage(
        offstage: !isShowSuspension,
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          alignment: Alignment.centerLeft,
          height: 28,
          color: ThemeUtils.dark ? Color(0xFF515151) : Color(0xFFF5F5F5),
          child: Text(
            item.dateStr,
            style: TextStyle(fontSize: 12, color: Colors.cyan),
          ),
        ),
      ),
      content: Slidable(
        controller: slidableController,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: InkWell(
          onTap: () {
            RouteUtil.push(
                context,
                TodoAddScreen(
                  todoType: todoType,
                  editKey: 1,
                  bean: item,
                ));
          },
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              item.title,
                              style: TextStyle(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Text(
                              item.content,
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xFF757575)),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: item.priority != 1,
                    child: Container(
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            color: Color(0xFFF44336), width: 0.5),
                        borderRadius: new BorderRadius.vertical(
                            top: Radius.elliptical(2, 2),
                            bottom: Radius.elliptical(2, 2)),
                      ),
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Text(
                        "重要",
                        style: TextStyle(
                            fontSize: 10, color: const Color(0xFFF44336)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 1),
            ],
          ),
        ),
        secondaryActions: <Widget>[
          InkWell(
            onTap: () {
              widget.updateTodoCallback(item.id);
            },
            child: Container(
              alignment: Alignment.center,
              color: const Color(0xFF4CAF50),
              child: Text(
                isTodo ? '已完成' : '复原',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              widget.deleteItemCallback(item.id);
            },
            child: Container(
              alignment: Alignment.center,
              color: Colors.red,
              child: Text(
                '删除',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
