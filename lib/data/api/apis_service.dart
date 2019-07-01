import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/data/model/article_model.dart';
import 'package:flutter_wanandroid/data/model/banner_model.dart';
import 'package:flutter_wanandroid/data/model/knowledge_tree_model.dart';
import 'package:flutter_wanandroid/data/model/navigation_model.dart';
import 'package:flutter_wanandroid/data/model/project_article_model.dart';
import 'package:flutter_wanandroid/data/model/project_tree_model.dart';
import 'package:flutter_wanandroid/data/model/wx_article_model.dart';
import 'package:flutter_wanandroid/data/model/wx_chapters_model.dart';
import 'package:flutter_wanandroid/net/dio_manager.dart';

class ApiService {
  Options _getOptions() {
    Map<String, String> map = new Map();
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
}
