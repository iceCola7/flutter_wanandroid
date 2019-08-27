import 'dart:convert' show json;

import 'package:flutter_wanandroid/utils/string_util.dart';

class KnowledgeTreeModel {
  int errorCode;
  String errorMsg;
  List<KnowledgeTreeBean> data;

  KnowledgeTreeModel.fromParams({this.errorCode, this.errorMsg, this.data});

  factory KnowledgeTreeModel(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new KnowledgeTreeModel.fromJson(json.decode(jsonStr))
          : new KnowledgeTreeModel.fromJson(jsonStr);

  KnowledgeTreeModel.fromJson(jsonRes) {
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']) {
      data.add(
          dataItem == null ? null : new KnowledgeTreeBean.fromJson(dataItem));
    }
  }

  @override
  String toString() {
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null ? '${json.encode(errorMsg)}' : 'null'},"data": $data}';
  }
}

class KnowledgeTreeBean {
  int courseId;
  int id;
  int order;
  int parentChapterId;
  int visible;
  bool userControlSetTop;
  String name;
  List<KnowledgeTreeChildBean> children;

  KnowledgeTreeBean.fromParams(
      {this.courseId,
      this.id,
      this.order,
      this.parentChapterId,
      this.visible,
      this.userControlSetTop,
      this.name,
      this.children});

  KnowledgeTreeBean.fromJson(jsonRes) {
    courseId = jsonRes['courseId'];
    id = jsonRes['id'];
    order = jsonRes['order'];
    parentChapterId = jsonRes['parentChapterId'];
    visible = jsonRes['visible'];
    userControlSetTop = jsonRes['userControlSetTop'];
    name = StringUtil.urlDecoder(jsonRes['name']);
    children = jsonRes['children'] == null ? null : [];

    for (var childrenItem in children == null ? [] : jsonRes['children']) {
      children.add(childrenItem == null
          ? null
          : new KnowledgeTreeChildBean.fromJson(childrenItem));
    }
  }

  @override
  String toString() {
    return '{"courseId": $courseId,"id": $id,"order": $order,"parentChapterId": $parentChapterId,"visible": $visible,"userControlSetTop": $userControlSetTop,"name": ${name != null ? '${json.encode(name)}' : 'null'},"children": $children}';
  }
}

class KnowledgeTreeChildBean {
  int courseId;
  int id;
  int order;
  int parentChapterId;
  int visible;
  bool userControlSetTop;
  String name;
  List<dynamic> children;

  KnowledgeTreeChildBean.fromParams(
      {this.courseId,
      this.id,
      this.order,
      this.parentChapterId,
      this.visible,
      this.userControlSetTop,
      this.name,
      this.children});

  KnowledgeTreeChildBean.fromJson(jsonRes) {
    courseId = jsonRes['courseId'];
    id = jsonRes['id'];
    order = jsonRes['order'];
    parentChapterId = jsonRes['parentChapterId'];
    visible = jsonRes['visible'];
    userControlSetTop = jsonRes['userControlSetTop'];
    name = jsonRes['name'];
    children = jsonRes['children'] == null ? null : [];

    for (var childrenItem in children == null ? [] : jsonRes['children']) {
      children.add(childrenItem);
    }
  }

  @override
  String toString() {
    return '{"courseId": $courseId,"id": $id,"order": $order,"parentChapterId": $parentChapterId,"visible": $visible,"userControlSetTop": $userControlSetTop,"name": ${name != null ? '${json.encode(name)}' : 'null'},"children": $children}';
  }
}
