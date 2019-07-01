import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/data/model/article_model.dart';
import 'package:flutter_wanandroid/data/model/banner_model.dart';
import 'package:flutter_wanandroid/net/dio_manager.dart';
import 'package:flutter_wanandroid/data/model/knowledge_tree_model.dart';

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
        .get(Apis.SYSTEM_TREE_LIST, options: _getOptions())
        .then((response) {
      callback(KnowledgeTreeModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }
}
