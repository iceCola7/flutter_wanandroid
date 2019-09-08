class UserScoreModel {
  UserScoreBody data;
  int errorCode;
  String errorMsg;

  UserScoreModel({this.data, this.errorCode, this.errorMsg});

  UserScoreModel.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? new UserScoreBody.fromJson(json['data']) : null;
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class UserScoreBody {
  int curPage;
  List<UserScoreBean> datas;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  UserScoreBody(
      {this.curPage,
      this.datas,
      this.offset,
      this.over,
      this.pageCount,
      this.size,
      this.total});

  UserScoreBody.fromJson(Map<String, dynamic> json) {
    curPage = json['curPage'];
    if (json['datas'] != null) {
      datas = new List<UserScoreBean>();
      json['datas'].forEach((v) {
        datas.add(new UserScoreBean.fromJson(v));
      });
    }
    offset = json['offset'];
    over = json['over'];
    pageCount = json['pageCount'];
    size = json['size'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['curPage'] = this.curPage;
    if (this.datas != null) {
      data['datas'] = this.datas.map((v) => v.toJson()).toList();
    }
    data['offset'] = this.offset;
    data['over'] = this.over;
    data['pageCount'] = this.pageCount;
    data['size'] = this.size;
    data['total'] = this.total;
    return data;
  }
}

class UserScoreBean {
  int coinCount;
  int date;
  String desc;
  int id;
  String reason;
  int type;
  int userId;
  String userName;

  UserScoreBean(
      {this.coinCount,
      this.date,
      this.desc,
      this.id,
      this.reason,
      this.type,
      this.userId,
      this.userName});

  UserScoreBean.fromJson(Map<String, dynamic> json) {
    coinCount = json['coinCount'];
    date = json['date'];
    desc = json['desc'];
    id = json['id'];
    reason = json['reason'];
    type = json['type'];
    userId = json['userId'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coinCount'] = this.coinCount;
    data['date'] = this.date;
    data['desc'] = this.desc;
    data['id'] = this.id;
    data['reason'] = this.reason;
    data['type'] = this.type;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    return data;
  }
}
