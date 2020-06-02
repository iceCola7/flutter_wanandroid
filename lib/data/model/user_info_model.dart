class UserInfoModel {
  UserInfoBean data;
  int errorCode;
  String errorMsg;

  UserInfoModel({this.data, this.errorCode, this.errorMsg});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? new UserInfoBean.fromJson(json['data']) : null;
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

class UserInfoBean {
  int coinCount;
  int level;
  int rank;
  int userId;
  String username;

  UserInfoBean(
      {this.coinCount, this.level, this.rank, this.userId, this.username});

  UserInfoBean.fromJson(Map<String, dynamic> json) {
    coinCount = json['coinCount'];
    level = json["level"];
    rank = json['rank'];
    userId = json['userId'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coinCount'] = this.coinCount;
    data["level"] = this.level;
    data['rank'] = this.rank;
    data['userId'] = this.userId;
    data['username'] = this.username;
    return data;
  }
}
