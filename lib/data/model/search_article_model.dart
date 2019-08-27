import 'package:flutter_wanandroid/utils/string_util.dart';

class SearchArticleModel {
  String errorMsg;
  int errorCode;
  SearchArticleListBean data;

  static SearchArticleModel fromMap(Map<String, dynamic> map) {
    SearchArticleModel searchArticleModel = new SearchArticleModel();
    searchArticleModel.errorMsg = map['errorMsg'];
    searchArticleModel.errorCode = map['errorCode'];
    searchArticleModel.data = SearchArticleListBean.fromMap(map['data']);
    return searchArticleModel;
  }

  static List<SearchArticleModel> fromMapList(dynamic mapList) {
    List<SearchArticleModel> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class SearchArticleListBean {
  bool over;
  int curPage;
  int offset;
  int pageCount;
  int size;
  int total;
  List<SearchArticleBean> datas;

  static SearchArticleListBean fromMap(Map<String, dynamic> map) {
    SearchArticleListBean dataBean = new SearchArticleListBean();
    dataBean.over = map['over'];
    dataBean.curPage = map['curPage'];
    dataBean.offset = map['offset'];
    dataBean.pageCount = map['pageCount'];
    dataBean.size = map['size'];
    dataBean.total = map['total'];
    dataBean.datas = SearchArticleBean.fromMapList(map['datas']);
    return dataBean;
  }

  static List<SearchArticleListBean> fromMapList(dynamic mapList) {
    List<SearchArticleListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class SearchArticleBean {
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
  bool collect;
  bool fresh;
  int chapterId;
  int courseId;
  int id;
  int publishTime;
  int superChapterId;
  int type;
  int userId;
  int visible;
  int zan;
  List<TagListBean> tags;

  static SearchArticleBean fromMap(Map<String, dynamic> map) {
    SearchArticleBean datasListBean = new SearchArticleBean();
    datasListBean.apkLink = map['apkLink'];
    datasListBean.author = map['author'];
    datasListBean.chapterName = StringUtil.urlDecoder(map['chapterName']);
    datasListBean.desc = StringUtil.urlDecoder(map['desc']);
    datasListBean.envelopePic = map['envelopePic'];
    datasListBean.link = map['link'];
    datasListBean.niceDate = map['niceDate'];
    datasListBean.origin = map['origin'];
    datasListBean.projectLink = map['projectLink'];
    datasListBean.superChapterName =
        StringUtil.urlDecoder(map['superChapterName']);
    datasListBean.title = StringUtil.urlDecoder(map['title']);
    datasListBean.collect = map['collect'];
    datasListBean.fresh = map['fresh'];
    datasListBean.chapterId = map['chapterId'];
    datasListBean.courseId = map['courseId'];
    datasListBean.id = map['id'];
    datasListBean.publishTime = map['publishTime'];
    datasListBean.superChapterId = map['superChapterId'];
    datasListBean.type = map['type'];
    datasListBean.userId = map['userId'];
    datasListBean.visible = map['visible'];
    datasListBean.zan = map['zan'];
    datasListBean.tags = TagListBean.fromMapList(map['tags']);
    return datasListBean;
  }

  static List<SearchArticleBean> fromMapList(dynamic mapList) {
    List<SearchArticleBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class TagListBean {
  String name;
  String url;

  static TagListBean fromMap(Map<String, dynamic> map) {
    TagListBean tagsListBean = new TagListBean();
    tagsListBean.name = map['name'];
    tagsListBean.url = map['url'];
    return tagsListBean;
  }

  static List<TagListBean> fromMapList(dynamic mapList) {
    List<TagListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
