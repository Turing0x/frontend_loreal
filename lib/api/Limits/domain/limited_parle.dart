import 'dart:convert';

LimitedParleModel limitedParleFromJson(String str) => LimitedParleModel.fromJson(json.decode(str));
String limitedParleToJson(LimitedParleModel data) => json.encode(data.toJson());

class LimitedParleModel {
  LimitedParleModel({
    required this.bola,
  });

  Map<String, dynamic> bola;

  factory LimitedParleModel.fromJson(Map<String, dynamic> json) => LimitedParleModel(
    bola: json['bola'],
  );

  Map<String, dynamic> toJson() => {
    'bola': bola,
  };
}
