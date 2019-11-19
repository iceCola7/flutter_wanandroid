class Apis {
  static const String BASE_HOST = "https://www.wanandroid.com";

  /// 首页轮播
  static const String HOME_BANNER = BASE_HOST + "/banner/json";

  /// 首页列表
  static const String HOME_ARTICLE_LIST = BASE_HOST + "/article/list";

  /// 首页置顶文章列表
  static const String HOME_TOP_ARTICLE_LIST = BASE_HOST + "/article/top/json";

  /// 知识体系
  static const String KNOWLEDGE_TREE_LIST = BASE_HOST + "/tree/json";

  /// 知识体系详情
  static const String KNOWLEDGE_DETAIL_LIST = BASE_HOST + "/article/list";

  /// 获取公众号名称
  static const String WX_CHAPTERS_LIST = BASE_HOST + "/wxarticle/chapters/json";

  /// 公众号文章数据列表
  static const String WX_ARTICLE_LIST = BASE_HOST + "/wxarticle/list";

  /// 导航数据列表
  static const String NAVIGATION_LIST = BASE_HOST + "/navi/json";

  /// 项目分类列表
  static const String PROJECT_TREE_LIST = BASE_HOST + "/project/tree/json";

  /// 项目文章列表数据
  static const String PROJECT_ARTICLE_LIST = BASE_HOST + "/project/list";

  /// 搜索热词列表
  static const String SEARCH_HOT_LIST = BASE_HOST + "/hotkey/json";

  /// 搜索文章类别列表
  static const String SEARCH_ARTICLE_LIST = BASE_HOST + "/article/query";

  /// 用户登录
  static const String USER_LOGIN = BASE_HOST + "/user/login";

  /// 用户注册
  static const String USER_REGISTER = BASE_HOST + "/user/register";

  /// 收藏列表
  static const String COLLECTION_LIST = BASE_HOST + "/lg/collect/list";

  /// 新增收藏(收藏站内文章)
  static const String ADD_COLLECTION = BASE_HOST + "/lg/collect";

  /// 新增收藏(收藏站外文章)
  static const String ADD_COLLECTION_2 = BASE_HOST + "/lg/collect/add/json";

  /// 取消收藏
  static const String CANCEL_COLLECTION = BASE_HOST + "/lg/uncollect_originId";

  /// 退出登录
  static const String USER_LOGOUT = BASE_HOST + "/user/logout/json";

  /// TODO 列表
  static const String TODO_LIST = BASE_HOST + "/lg/todo/v2/list";

  /// 未完成TODO列表
  static const String NO_TODO_LIST = BASE_HOST + "/lg/todo/listnotdo";

  /// 已完成TODO列表
  static const String DONE_TODO_LIST = BASE_HOST + "/lg/todo/listdone";

  /// 新增一个TODO
  static const String ADD_TODO = BASE_HOST + "/lg/todo/add/json";

  /// 更新TODO
  static const String UPDATE_TODO = BASE_HOST + "/lg/todo/update";

  /// 仅更新完成状态Todo
  static const String UPDATE_TODO_STATE = BASE_HOST + "/lg/todo/done";

  /// 根据ID删除TODO
  static const String DELETE_TODO_BY_ID = BASE_HOST + "/lg/todo/delete";

  /// 用户个人信息
  static const String USER_INFO = BASE_HOST + "/lg/coin/userinfo/json";

  /// 我的积分
  static const String USER_SCORE_LIST = BASE_HOST + "/lg/coin/list";

  /// 积分排行榜
  static const String RANK_LIST = BASE_HOST + "/coin/rank";

  /// 广场列表
  static const String SQUARE_LIST = BASE_HOST + "/user_article/list";

  /// 我的分享列表
  static const String SHARE_LIST = BASE_HOST + "/user/lg/private_articles";

  /// 删除已分享的文章
  static const String DELETE_SHARE_ARTICLE =
      BASE_HOST + "/lg/user_article/delete";

  /// 分享文章
  static const String SHARE_ARTICLE_ADD =
      BASE_HOST + "/lg/user_article/add/json";
}
