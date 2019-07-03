class HotWordModel {
  int errorCode;
  String errorMsg;
  List<HotWordBean> data;

  static HotWordModel fromMap(Map<String, dynamic> map) {
    HotWordModel hotWordModel = new HotWordModel();
    hotWordModel.errorMsg = map['errorMsg'];
    hotWordModel.errorCode = map['errorCode'];
    hotWordModel.data = HotWordBean.fromMapList(map['data']);
    return hotWordModel;
  }

  static List<HotWordModel> fromMapList(dynamic mapList) {
    List<HotWordModel> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class HotWordBean {
  int id;
  String name;
  String link;
  int order;
  int visible;

  static HotWordBean fromMap(Map<String, dynamic> map) {
    HotWordBean dataListBean = new HotWordBean();
    dataListBean.link = map['link'];
    dataListBean.name = map['name'];
    dataListBean.id = map['id'];
    dataListBean.order = map['order'];
    dataListBean.visible = map['visible'];
    return dataListBean;
  }

  static List<HotWordBean> fromMapList(dynamic mapList) {
    List<HotWordBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
