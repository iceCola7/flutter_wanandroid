import 'dart:convert' show json;

import 'package:flutter_wanandroid/utils/string_util.dart';

class TodoListModel {
  int errorCode;
  String errorMsg;
  TodoListBean data;

  TodoListModel.fromParams({this.errorCode, this.errorMsg, this.data});

  factory TodoListModel(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new TodoListModel.fromJson(json.decode(jsonStr))
          : new TodoListModel.fromJson(jsonStr);

  TodoListModel.fromJson(jsonRes) {
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = jsonRes['data'] == null
        ? null
        : new TodoListBean.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null ? '${json.encode(errorMsg)}' : 'null'},"data": $data}';
  }
}

class TodoListBean {
  int curPage;
  int offset;
  int pageCount;
  int size;
  int total;
  bool over;
  List<TodoBean> datas;

  TodoListBean.fromParams(
      {this.curPage,
      this.offset,
      this.pageCount,
      this.size,
      this.total,
      this.over,
      this.datas});

  TodoListBean.fromJson(jsonRes) {
    curPage = jsonRes['curPage'];
    offset = jsonRes['offset'];
    pageCount = jsonRes['pageCount'];
    size = jsonRes['size'];
    total = jsonRes['total'];
    over = jsonRes['over'];
    datas = jsonRes['datas'] == null ? null : [];

    for (var datasItem in datas == null ? [] : jsonRes['datas']) {
      datas.add(datasItem == null ? null : new TodoBean.fromJson(datasItem));
    }
  }

  @override
  String toString() {
    return '{"curPage": $curPage,"offset": $offset,"pageCount": $pageCount,"size": $size,"total": $total,"over": $over,"datas": $datas}';
  }
}

class TodoBean {
  int completeDate;
  String completeDateStr;
  String content;
  int date;
  String dateStr;
  int id;
  int priority;
  int status;
  String title;
  int type;
  int userId;

  TodoBean.fromParams(
      {this.completeDate,
      this.completeDateStr,
      this.content,
      this.date,
      this.dateStr,
      this.id,
      this.priority,
      this.status,
      this.title,
      this.type,
      this.userId});

  TodoBean.fromJson(jsonRes) {
    completeDate = jsonRes['completeDate'];
    completeDateStr = jsonRes['completeDateStr'];
    content = StringUtil.urlDecoder(jsonRes['content']);
    date = jsonRes['date'];
    dateStr = jsonRes['dateStr'];
    id = jsonRes['id'];
    priority = jsonRes['priority'];
    status = jsonRes['status'];
    title = StringUtil.urlDecoder(jsonRes['title']);
    type = jsonRes['type'];
    userId = jsonRes['userId'];
  }

  @override
  String toString() {
    return '{"completeDate": $completeDate,"completeDateStr": $completeDateStr,"content": $content,"date": $date,"dateStr": $dateStr,"id": $id,"priority": $priority,'
        '"status": $status,"title": $title,"type": $type,"userId": $userId}}';
  }
}
