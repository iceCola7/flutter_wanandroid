class HotWordModel {
  List<HotWordBean> data;
  int errorCode;
  String errorMsg;

  HotWordModel({this.data, this.errorCode, this.errorMsg});

  HotWordModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<HotWordBean>();
      json['data'].forEach((v) {
        data.add(new HotWordBean.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class HotWordBean {
  int id;
  String link;
  String name;
  int order;
  int visible;

  HotWordBean({this.id, this.link, this.name, this.order, this.visible});

  HotWordBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    name = json['name'];
    order = json['order'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['link'] = this.link;
    data['name'] = this.name;
    data['order'] = this.order;
    data['visible'] = this.visible;
    return data;
  }
}
