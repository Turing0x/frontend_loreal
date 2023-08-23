import 'dart:convert';

LimitedBallModel limitedBallFromJson(String str) => LimitedBallModel.fromJson(json.decode(str));
String limitedBallToJson(LimitedBallModel data) => json.encode(data.toJson());

class LimitedBallModel {
  LimitedBallModel({
    required this.bola,
  });

  Map<String, dynamic> bola;

  factory LimitedBallModel.fromJson(Map<String, dynamic> json) => LimitedBallModel(
    bola: json['bola'],
  );

  Map<String, dynamic> toJson() => {
    'bola': bola,
  };
}
