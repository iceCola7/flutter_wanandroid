class HistoryBean {
  int id;
  String name;

  static HistoryBean fromMap(Map<String, dynamic> map) {
    HistoryBean historyBean = new HistoryBean();
    historyBean.id = map['id'];
    historyBean.name = map['name'];
    return historyBean;
  }

  static List<HistoryBean> fromMapList(dynamic mapList) {
    List<HistoryBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

}