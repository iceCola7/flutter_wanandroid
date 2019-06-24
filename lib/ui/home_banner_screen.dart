import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/banner_model.dart';

class HomeBannerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeBannerState();
  }
}

class HomeBannerState extends State<HomeBannerScreen> {
  List<BannerBean> bannerList = new List();

  @override
  void initState() {
    super.initState();
    _getBannerList();
  }

  void _getBannerList() {
    ApiService().getBannerList((BannerModel _bannerModel) {
      if (_bannerModel.data.length > 0) {
        setState(() {
          bannerList = _bannerModel.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        if (bannerList[index] == null || bannerList[index].imagePath == null) {
          return new Container(
            color: Colors.grey[100],
          );
        } else {
          return InkWell(
            child: new Container(
              child: new Image.network(
                bannerList[index].imagePath,
                fit: BoxFit.fill,
              ),
            ),
            onTap: () {},
          );
        }
      },
    );
  }
}
