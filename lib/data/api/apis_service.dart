import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/data/model/article_model.dart';
import 'package:flutter_wanandroid/data/model/banner_model.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/data/model/collection_model.dart';
import 'package:flutter_wanandroid/data/model/hot_word_model.dart';
import 'package:flutter_wanandroid/data/model/knowledge_detail_model.dart';
import 'package:flutter_wanandroid/data/model/knowledge_tree_model.dart';
import 'package:flutter_wanandroid/data/model/navigation_model.dart';
import 'package:flutter_wanandroid/data/model/project_article_model.dart';
import 'package:flutter_wanandroid/data/model/project_tree_model.dart';
import 'package:flutter_wanandroid/data/model/search_article_model.dart';
import 'package:flutter_wanandroid/data/model/todo_list_model.dart';
import 'package:flutter_wanandroid/data/model/user_model.dart';
import 'package:flutter_wanandroid/data/model/wx_article_model.dart';
import 'package:flutter_wanandroid/data/model/wx_chapters_model.dart';
import 'package:flutter_wanandroid/net/index.dart';

ApiService _apiService = new ApiService();

ApiService get apiService => _apiService;

class ApiService {
  Options _getOptions() {
    Map<String, String> map = new Map();
    map["Cookie"] = User().cookie.toString();
    return Options(headers: map);
  }

  ///  获取首页轮播数据
  void getBannerList(Function callback) async {
    dio.get(Apis.HOME_BANNER, options: _getOptions()).then((response) {
      callback(BannerModel(response.data));
    });
  }

  /// 获取首页置顶文章数据
  void getTopArticleList(Function callback, Function errorCallback) async {
    dio
        .get(Apis.HOME_TOP_ARTICLE_LIST, options: _getOptions())
        .then((response) {
      callback(TopArticleModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取首页文章列表数据
  void getArticleList(
      Function callback, Function errorCallback, int _page) async {
    dio
        .get(Apis.HOME_ARTICLE_LIST + "/$_page/json", options: _getOptions())
        .then((response) {
      callback(ArticleModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取知识体系数据
  void getKnowledgeTreeList(Function callback, Function errorCallback) async {
    dio.get(Apis.KNOWLEDGE_TREE_LIST, options: _getOptions()).then((response) {
      callback(KnowledgeTreeModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取知识体系详情数据
  void getKnowledgeDetailList(
      Function callback, Function errorCallback, int _page, int _id) async {
    dio
        .get(Apis.KNOWLEDGE_DETAIL_LIST + "/$_page/json?cid=$_id",
            options: _getOptions())
        .then((response) {
      callback(KnowledgeDetailModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取公众号名称
  void getWXChaptersList(Function callback, Function errorCallback) async {
    dio.get(Apis.WX_CHAPTERS_LIST, options: _getOptions()).then((response) {
      callback(WXChaptersModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取公众号文章列表数据
  void getWXArticleList(
      Function callback, Function errorCallback, int _id, int _page) async {
    dio
        .get(Apis.WX_ARTICLE_LIST + "/$_id/$_page/json", options: _getOptions())
        .then((response) {
      callback(WXArticleModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取导航列表数据
  void getNavigationList(Function callback, Function errorCallback) async {
    dio.get(Apis.NAVIGATION_LIST, options: _getOptions()).then((response) {
      callback(NavigationModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取项目分类列表数据
  void getProjectTreeList(Function callback, Function errorCallback) async {
    dio.get(Apis.PROJECT_TREE_LIST, options: _getOptions()).then((response) {
      callback(ProjectTreeModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取项目文章列表数据
  void getProjectArticleList(
      Function callback, Function errorCallback, int _id, int _page) async {
    dio
        .get(Apis.PROJECT_ARTICLE_LIST + "/$_page/json?cid=$_id",
            options: _getOptions())
        .then((response) {
      callback(ProjectArticleListModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取搜索热词列表数据
  void getSearchHotList(Function callback, Function errorCallback) async {
    dio.get(Apis.SEARCH_HOT_LIST, options: _getOptions()).then((response) {
      callback(HotWordModel.fromMap(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取搜索的文章列表
  void getSearchArticleList(Function callback, Function errorCallback,
      int _page, String _keyword) async {
    FormData formData = new FormData.from({"k": _keyword});
    dio
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
    dio
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
    dio
        .post(Apis.USER_REGISTER, data: formData, options: null)
        .then((response) {
      callback(UserModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取收藏列表
  void getCollectionList(
      Function callback, Function errorCallback, int _page) async {
    dio
        .get(Apis.COLLECTION_LIST + "/$_page/json", options: _getOptions())
        .then((response) {
      callback(CollectionModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 新增收藏(收藏站内文章)
  void addCollection(Function callback, Function errorCallback, int _id) async {
    dio
        .post(Apis.ADD_COLLECTION + "/$_id/json", options: _getOptions())
        .then((response) {
      callback(BaseModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 取消收藏
  void cancelCollection(
      Function callback, Function errorCallback, int _id) async {
    dio
        .post(Apis.CANCEL_COLLECTION + "/$_id/json", options: _getOptions())
        .then((response) {
      callback(BaseModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 退出登录
  void logout(Function callback, Function errorCallback) async {
    dio.get(Apis.USER_LOGOUT).then((response) {
      callback(BaseModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取TODO列表数据
  void getTodoList(Function callback, Function errorCallback, int _page) async {
    dio
        .get(Apis.TODO_LIST + "/$_page/json", options: _getOptions())
        .then((response) {
      callback(TodoListModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取未完成TODO列表
  void getNoTodoList(
      Function callback, Function errorCallback, int _type, int _page) async {
    dio
        .post(Apis.NO_TODO_LIST + "/$_type/json/$_page", options: _getOptions())
        .then((response) {
      callback(TodoListModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取已完成TODO列表
  void getDoneTodoList(
      Function callback, Function errorCallback, int _type, int _page) async {
    dio
        .post(Apis.DONE_TODO_LIST + "/$_type/json/$_page",
            options: _getOptions())
        .then((response) {
      callback(TodoListModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 新增一个TODO
  void addTodo(Function callback, Function errorCallback, params) async {
    dio
        .post(Apis.ADD_TODO, queryParameters: params, options: _getOptions())
        .then((response) {
      callback(BaseModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 根据ID更新TODO
  void updateTodo(
      Function callback, Function errorCallback, int _id, params) async {
    dio
        .post(Apis.UPDATE_TODO + "/$_id/json",
            queryParameters: params, options: _getOptions())
        .then((response) {
      callback(BaseModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 仅更新完成状态Todo
  void updateTodoState(
      Function callback, Function errorCallback, int _id, params) async {
    dio
        .post(Apis.UPDATE_TODO_STATE + "/$_id/json",
            queryParameters: params, options: _getOptions())
        .then((response) {
      callback(BaseModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 根据ID删除TODO
  void deleteTodoById(
      Function callback, Function errorCallback, int _id) async {
    dio
        .post(Apis.DELETE_TODO_BY_ID + "/$_id/json", options: _getOptions())
        .then((response) {
      callback(BaseModel(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }
}
