class Weather {
  int? temp; //気温
  int? tempMax;
  int? tempMin;
  String? descripttion; //天気状態
  double? lon; //経度
  double? lat; //緯度
  String? icon; //天気アイコン
  DateTime? time; //日時
  int? rainyPercent; //降水確率

  Weather({
    this.temp,
    this.tempMax,
    this.tempMin,
    this.descripttion,
    this.lon,
    this.lat,
    this.icon,
    this.time,
    this.rainyPercent,
  });
}
