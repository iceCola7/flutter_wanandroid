import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/banner_model.dart';
import 'package:flutter_wanandroid/utils/route_util.dart';
import 'package:flutter_wanandroid/widgets/custom_cached_image.dart';

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
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _bannerList.add(null);
    _getBannerList();
  }

  Future _getBannerList() async {
    apiService.getBannerList((BannerModel bannerModel) {
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
            return new Container(height: 0);
          } else {
            return InkWell(
              child: new Container(
                child: CustomCachedImage(imageUrl: _bannerList[index].imagePath),
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
