import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/banner_model.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';

class HomeBannerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeBannerState();
  }
}

class HomeBannerState extends State<HomeBannerScreen> {
  List<BannerBean> _bannerList = new List();

  @override
  void initState() {
    // super.initState();
    _bannerList.add(null);
    _getBannerList();
  }

  Future<Null> _getBannerList() async {
    ApiService().getBannerList((BannerModel bannerModel) {
      if (bannerModel.data.length > 0) {
        setState(() {
          _bannerList = bannerModel.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: _bannerList.length == 0,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          if (index >= _bannerList.length ||
              _bannerList[index] == null ||
              _bannerList[index].imagePath == null) {
            return new Container(
              color: Colors.grey[100],
            );
          } else {
            return InkWell(
              child: new Container(
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: _bannerList[index].imagePath,
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
              onTap: () {
                RouteUtil.toWebView(
                    context, _bannerList[index].title, _bannerList[index].url);
              },
            );
          }
        },
        itemCount: _bannerList.length,
        autoplay: true,
        pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
