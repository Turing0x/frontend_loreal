import 'dart:convert';

OnlyWinner onlyWinnerFromJson(String str) => OnlyWinner.fromJson(json.decode(str));

String onlyWinnerToJson(OnlyWinner data) => json.encode(data.toJson());

class OnlyWinner {
  String? play;
  String? owner;
  ElementData? element;

  OnlyWinner({
      this.play,
      this.owner,
      this.element,
  });

  factory OnlyWinner.fromJson(Map<String, dynamic> json) => OnlyWinner(
      play: json["play"],
      owner: json["owner"],
      element: json["element"] == null ? null : ElementData.fromJson(json["element"]),
  );

  Map<String, dynamic> toJson() => {
      "play": play,
      "owner": owner,
      "element": element?.toJson(),
  };
}

class ElementData {
  String? uuid;
  dynamic numplay;
  dynamic terminal;
  int? fijo;
  int? corrido;
  int? corrido2;
  int? dinero;

  ElementData({
      this.uuid,
      this.numplay,
      this.terminal,
      this.fijo,
      this.corrido,
      this.corrido2,
      this.dinero,
  });

  factory ElementData.fromJson(Map<String, dynamic> json) => ElementData(
      uuid: json["uuid"],
      numplay: json["numplay"],
      terminal: json["terminal"],
      fijo: json["fijo"],
      corrido: json["corrido"],
      corrido2: json["corrido2"],
      dinero: json["dinero"],
  );

  Map<String, dynamic> toJson() => {
      "uuid": uuid,
      "numplay": numplay,
      "terminal": terminal,
      "fijo": fijo,
      "corrido": corrido,
      "corrido2": corrido2,
      "dinero": dinero,
  };
}
