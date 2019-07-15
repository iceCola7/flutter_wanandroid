import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/data/model/article_model.dart';
import 'package:flutter_wanandroid/data/model/banner_model.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/data/model/collection_model.dart';
import 'package:flutter_wanandroid/data/model/hot_word_model.dart';
import 'package:flutter_wanandroid/data/model/knowledge_tree_model.dart';
import 'package:flutter_wanandroid/data/model/navigation_model.dart';
import 'package:flutter_wanandroid/data/model/project_article_model.dart';
import 'package:flutter_wanandroid/data/model/project_tree_model.dart';
import 'package:flutter_wanandroid/data/model/search_article_model.dart';
import 'package:flutter_wanandroid/data/model/user_model.dart';
import 'package:flutter_wanandroid/data/model/wx_article_model.dart';
import 'package:flutter_wanandroid/data/model/wx_chapters_model.dart';
import 'package:flutter_wanandroid/net/dio_manager.dart';

class ApiService {
  Options _getOptions() {
    Map<String, String> map = new Map();
    map["Cookie"] = User().cookie.toString();
    return Options(headers: map);
  }

  ///  获取首页轮播数据
  void getBannerList(Function callback) async {
    DioManager.singleton.dio
        .get(Apis.HOME_BANNER, options: _getOptions())
        .then((response) {
      callback(BannerModel(response.data));
    });
  }

  /// 获取首页置顶文章数据
  void getTopArticleList(Function callback, Function errorCallback) {
    DioManager.singleton.dio
        .get(Apis.HOME_TOP_ARTICLE_LIST, options: _getOptions())
        .then((response) {
      callback(TopArticleModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取首页文章列表数据
  void getArticleList(Function callback, Function errorCallback, int _page) {
    DioManager.singleton.dio
        .get(Apis.HOME_ARTICLE_LIST + "/$_page/json", options: _getOptions())
        .then((response) {
      callback(ArticleModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取知识体系数据
  void getKnowledgeTreeList(Function callback, Function errorCallback) {
    DioManager.singleton.dio
        .get(Apis.KNOWLEDGE_TREE_LIST, options: _getOptions())
        .then((response) {
      callback(KnowledgeTreeModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取公众号名称
  void getWXChaptersList(Function callback, Function errorCallback) {
    DioManager.singleton.dio
        .get(Apis.WX_CHAPTERS_LIST, options: _getOptions())
        .then((response) {
      callback(WXChaptersModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取公众号文章列表数据
  void getWXArticleList(
      Function callback, Function errorCallback, int _id, int _page) {
    DioManager.singleton.dio
        .get(Apis.WX_ARTICLE_LIST + "/$_id/$_page/json", options: _getOptions())
        .then((response) {
      callback(WXArticleModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取导航列表数据
  void getNavigationList(Function callback, Function errorCallback) {
    DioManager.singleton.dio
        .get(Apis.NAVIGATION_LIST, options: _getOptions())
        .then((response) {
      callback(NavigationModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取项目分类列表数据
  void getProjectTreeList(Function callback, Function errorCallback) {
    DioManager.singleton.dio
        .get(Apis.PROJECT_TREE_LIST, options: _getOptions())
        .then((response) {
      callback(ProjectTreeModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取项目文章列表数据
  void getProjectArticleList(
      Function callback, Function errorCallback, int _id, int _page) {
    DioManager.singleton.dio
        .get(Apis.PROJECT_ARTICLE_LIST + "/$_page/json?cid=$_id",
            options: _getOptions())
        .then((response) {
      callback(ProjectArticleListModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取搜索热词列表数据
  void getSearchHotList(Function callback, Function errorCallback) {
    DioManager.singleton.dio
        .get(Apis.SEARCH_HOT_LIST, options: _getOptions())
        .then((response) {
      callback(HotWordModel.fromMap(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取搜索的文章列表
  void getSearchArticleList(
      Function callback, Function errorCallback, int _page, String _keyword) {
    FormData formData = new FormData.from({"k": _keyword});
    DioManager.singleton.dio
        .post(Apis.SEARCH_ARTICLE_LIST + "/$_page/json",
            data: formData, options: _getOptions())
        .then((response) {
      callback(SearchArticleModel.fromMap(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 登录
  void login(Function callback, Function errorCallback, String _username,
      String _password) async {
    FormData formData =
        new FormData.from({"username": _username, "password": _password});
    DioManager.singleton.dio
        .post(Apis.USER_LOGIN, data: formData, options: _getOptions())
        .then((response) {
      callback(UserModel(response.data), response);
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 注册
  void register(Function callback, Function errorCallback, String _username,
      String _password) async {
    FormData formData = new FormData.from({
      "username": _username,
      "password": _password,
      "repassword": _password
    });
    DioManager.singleton.dio
        .post(Apis.USER_REGISTER, data: formData, options: null)
        .then((response) {
      callback(UserModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取收藏列表
  void getCollectionList(Function callback, Function errorCallback, int _page) {
    DioManager.singleton.dio
        .get(Apis.COLLECTION_LIST + "/$_page/json", options: _getOptions())
        .then((response) {
      callback(CollectionModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 新增收藏(收藏站内文章)
  void addCollection(Function callback, Function errorCallback, int _id) {
    DioManager.singleton.dio
        .post(Apis.ADD_COLLECTION + "/$_id/json", options: _getOptions())
        .then((response) {
      callback(BaseModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 取消收藏
  void cancelCollection(
      Function callback, Function errorCallback, int _id, int _originId) {
    FormData formData = new FormData.from({"originId": _originId});
    DioManager.singleton.dio
        .post(Apis.CANCEL_COLLECTION + "/$_id/json",
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }
}
