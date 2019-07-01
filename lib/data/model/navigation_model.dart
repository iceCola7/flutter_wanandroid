import 'dart:convert' show json;

class NavigationModel {
  int errorCode;
  String errorMsg;
  List<NavigationBean> data;

  NavigationModel.fromParams({this.errorCode, this.errorMsg, this.data});

  factory NavigationModel(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new NavigationModel.fromJson(json.decode(jsonStr))
          : new NavigationModel.fromJson(jsonStr);

  NavigationModel.fromJson(jsonRes) {
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']) {
      data.add(dataItem == null ? null : new NavigationBean.fromJson(dataItem));
    }
  }

  @override
  String toString() {
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null ? '${json.encode(errorMsg)}' : 'null'},"data": $data}';
  }
}

class NavigationBean {
  int cid;
  String name;
  List<NavigationArticleBean> articles;

  NavigationBean.fromParams({this.cid, this.name, this.articles});

  NavigationBean.fromJson(jsonRes) {
    cid = jsonRes['cid'];
    name = jsonRes['name'];
    articles = jsonRes['articles'] == null ? null : [];

    for (var articlesItem in articles == null ? [] : jsonRes['articles']) {
      articles.add(articlesItem == null
          ? null
          : new NavigationArticleBean.fromJson(articlesItem));
    }
  }

  @override
  String toString() {
    return '{"cid": $cid,"name": ${name != null ? '${json.encode(name)}' : 'null'},"articles": $articles}';
  }
}

class NavigationArticleBean {
  int chapterId;
  int courseId;
  int id;
  int publishTime;
  int superChapterId;
  int type;
  int userId;
  int visible;
  int zan;
  bool collect;
  bool fresh;
  String apkLink;
  String author;
  String chapterName;
  String desc;
  String envelopePic;
  String link;
  String niceDate;
  String origin;
  String projectLink;
  String superChapterName;
  String title;
  List<dynamic> tags;

  NavigationArticleBean.fromParams(
      {this.chapterId,
      this.courseId,
      this.id,
      this.publishTime,
      this.superChapterId,
      this.type,
      this.userId,
      this.visible,
      this.zan,
      this.collect,
      this.fresh,
      this.apkLink,
      this.author,
      this.chapterName,
      this.desc,
      this.envelopePic,
      this.link,
      this.niceDate,
      this.origin,
      this.projectLink,
      this.superChapterName,
      this.title,
      this.tags});

  NavigationArticleBean.fromJson(jsonRes) {
    chapterId = jsonRes['chapterId'];
    courseId = jsonRes['courseId'];
    id = jsonRes['id'];
    publishTime = jsonRes['publishTime'];
    superChapterId = jsonRes['superChapterId'];
    type = jsonRes['type'];
    userId = jsonRes['userId'];
    visible = jsonRes['visible'];
    zan = jsonRes['zan'];
    collect = jsonRes['collect'];
    fresh = jsonRes['fresh'];
    apkLink = jsonRes['apkLink'];
    author = jsonRes['author'];
    chapterName = jsonRes['chapterName'];
    desc = jsonRes['desc'];
    envelopePic = jsonRes['envelopePic'];
    link = jsonRes['link'];
    niceDate = jsonRes['niceDate'];
    origin = jsonRes['origin'];
    projectLink = jsonRes['projectLink'];
    superChapterName = jsonRes['superChapterName'];
    title = jsonRes['title'];
    tags = jsonRes['tags'] == null ? null : [];

    for (var tagsItem in tags == null ? [] : jsonRes['tags']) {
      tags.add(tagsItem);
    }
  }

  @override
  String toString() {
    return '{"chapterId": $chapterId,"courseId": $courseId,"id": $id,"publishTime": $publishTime,"superChapterId": $superChapterId,"type": $type,"userId": $userId,"visible": $visible,"zan": $zan,"collect": $collect,"fresh": $fresh,"apkLink": ${apkLink != null ? '${json.encode(apkLink)}' : 'null'},"author": ${author != null ? '${json.encode(author)}' : 'null'},"chapterName": ${chapterName != null ? '${json.encode(chapterName)}' : 'null'},"desc": ${desc != null ? '${json.encode(desc)}' : 'null'},"envelopePic": ${envelopePic != null ? '${json.encode(envelopePic)}' : 'null'},"link": ${link != null ? '${json.encode(link)}' : 'null'},"niceDate": ${niceDate != null ? '${json.encode(niceDate)}' : 'null'},"origin": ${origin != null ? '${json.encode(origin)}' : 'null'},"projectLink": ${projectLink != null ? '${json.encode(projectLink)}' : 'null'},"superChapterName": ${superChapterName != null ? '${json.encode(superChapterName)}' : 'null'},"title": ${title != null ? '${json.encode(title)}' : 'null'},"tags": $tags}';
  }
}
