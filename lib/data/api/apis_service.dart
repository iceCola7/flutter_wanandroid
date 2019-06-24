import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/data/model/banner_model.dart';
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
}
